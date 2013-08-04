class ProductsController < ApplicationController
  #require 'faster_csv' 
  before_filter :authenticate_admin
  # GET /products
  # GET /products.xml
  def index
    @search = Product.search(params[:search])
    @products = @search.all(:include => :category).paginate(:page => params[:page], :per_page => 50)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.xml
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        flash[:notice] = 'Product was successfully created.'
        format.html { redirect_to(@product) }
        format.xml  { render :xml => @product, :status => :created, :location => @product }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        flash[:notice] = 'Product was successfully updated.'
        format.html { redirect_to(@product) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = Product.find(params[:id])
   
    if @product.verify_for_destroy
      flash[:notice] = "Deleted successfully"
    else
      flash[:error] = "Cannot delete the product because it's in use"
    end

    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
    end
  end
  

  
  def import_csv
       n=0
       begin
         import_file = File.new(RAILS_ROOT + "/public/products.csv", "r")
         #FasterCSV.parse("C:/Users/sony/Desktop/MFO1_Part_List.csv",:headers=>true) do |row|  
         
         FasterCSV.parse(import_file.read,:headers=>true).each do |row|

         unless Product.find_by_part_number(row[5])
           c = Product.new   
           c.part_number = row[5]
           c.part_name = row[9]
           c.description = row[1]
           category = Category.find_by_name(row[3])
           category ? c.category_id = category.id : c.category_id = 0
           c.technology = row[2]
           c.processed_parts = row[6]
           c.processed_part_description = row[13]
           c.prms_description = row[7]
           c.prms_description_1 = row[8]
           #c.procedure_product_id = row[3]  
           
           
           if row[7].include?("LH") and row[7].include?("RH") 
            side = "Common"
           elsif row[7].include?("RH")
            side = "Right"
           elsif row[7].include?("LH")
            side = "Left"
           else
            side = "Common"
           end
          
          
           c.side = side
           
           if c.save  
             n+=1  
             GC.start if n%50==0  
           end  
          
         end
       end
       import_file.close
       flash.now[:notice]="CSV Import Successful,  #{n} new records added to data base"  
       redirect_to(products_url)
     rescue
       flash[:error]="CSV file not found"  
       redirect_to(products_url)
     end
  end
  
  
end
