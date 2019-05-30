global class PointOfSalesConnection extends DataSource.Connection {
    
    private Datasource.ConnectionParams conParam;
    
    // constructor
    global PointOfSalesConnection(DataSource.ConnectionParams connectionParams){
        conParam = connectionParams;
    }
    
    
    //method is invoked if global search is used ot SOSL is issued
    
    override global List<DataSource.TableResult> search(DataSource.SearchContext context){
        List<DataSource.TableResult> results = new List<DataSource.TableResult>();
        for (DataSource.TableSelection tableSelection : context.tableSelections){
            results.add(DataSource.TableResult.get(tableSelection, getRows()));
        }
        
        return results;
    }
    
    // Abstract Method sync must be implemented as part of DataSource.Connection class
    // this method would define Schema of External Object
    // note: ExternialId and DisplayUrl are mandatory column
    
    override global List<DataSource.Table> sync(){
        List<DataSource.Table> tables = new List<DataSource.Table>();
        
        // map with external object 
        List<DataSource.Column> columns = new List<DataSource.Column>();
        
        
        columns.add(DataSource.Column.text('item_name',100));
        columns.add(DataSource.Column.text('retail_price',10));
        columns.add(DataSource.Column.text('pomo_price',10));
        columns.add(DataSource.Column.text('most_recent_vendor',30));
        columns.add(DataSource.Column.text('created_by',30));
        columns.add(DataSource.Column.text('order',10));
        columns.add(DataSource.Column.text('inventory',10));
        columns.add(DataSource.Column.text('adjustment',10));
        columns.add(DataSource.Column.text('status',10));
        columns.add(DataSource.Column.text('sales',10));
        columns.add(DataSource.Column.text('forecast_sales_three_months',10));
        columns.add(DataSource.Column.text('need_to_order_for_next_three_months',10));
        columns.add(DataSource.Column.text('annualized_sales',10));
        columns.add(DataSource.Column.text('annualized_qty',10));
        columns.add(DataSource.Column.text('category',20));
        columns.add(DataSource.Column.text('image_url',2000));
        columns.add(DataSource.Column.text('last_edited_by',20));
        columns.add(DataSource.Column.text('last_cost',6));
        columns.add(DataSource.Column.integer('barcode',17));
        columns.add(DataSource.Column.text('unit',10));
        columns.add(DataSource.Column.text('created_at',15));
        columns.add(DataSource.Column.text('updated_at',15));
        
        // Menadatory column
        columns.add(DataSource.Column.text('ExternalId',255)); 
        columns.add(DataSource.Column.url('DisplayUrl'));
        
        tables.add(DataSource.Table.get('POSProductsList', 'Title', columns)); 
        return tables;    
    }
    
    //this is a method that called everytime when SOQL is issued against external Object or while using list view or viewing detail pages.
    //Note: Ideally searching should be done at server side however for sake of simplicity, we would be using "dataSource.QueryUtils" class provideed by salesforce. In this case, filtering and sorting would be done in salesforce
    //once respnese returned by external rest api.
    
    
    override global DataSource.TableResult query(DataSource.QueryContext context) {
        if (context.tableSelection.columnsSelected.size() == 1 && context.tableSelection.columnsSelected.get(0).aggregation == DataSource.QueryAggregation.COUNT) {
            List<Map<String,Object>> rows = getRows( );
            List<Map<String,Object>> response = DataSource.QueryUtils.filter(context, getRows( ));
            List<Map<String, Object>> countResponse = new List<Map<String, Object>>();
            Map<String, Object> countRow = new Map<String, Object>();
            countRow.put( context.tableSelection.columnsSelected.get(0).columnName, response.size());
            countResponse.add(countRow);
            return DataSource.TableResult.get(context, countResponse);
        } else {
            List<Map<String,Object>> filteredRows =  DataSource.QueryUtils.filter(context, getRows( ));
            List<Map<String,Object>> sortedRows = DataSource.QueryUtils.sort(context, filteredRows);
            List<Map<String,Object>> limitedRows = DataSource.QueryUtils.applyLimitAndOffset(context, sortedRows);
            return DataSource.TableResult.get(context, limitedRows);
        }
    }
    
    
    
    
    // make REST callout to exernal system and parse the resule in required formaot
    
    private List<Map<String,Object>> getRows( ){
        List<Map<String, Object>> lstReturnDataset =  new List<Map<String, Object>>();
        
        HttpRequest req = new HttpRequest();
        req.setEndPoint('https://limitless-fjord-48119.herokuapp.com/api/v1/products');
        req.setMethod('GET');
        HttpResponse res = new Http().send(req);
        
        
        // get the items on the beginning and use the Map.get method to extract the list of objects
        String response = '{"items": ' + res.getBody() + '}';
        Map<String, Object> json_resp = ( Map<String, Object>)JSON.deserializeUntyped(response);
        List<Object> products = (List<Object>)json_resp.get('items');
        
        
        for(Object product : products){
            Map<String, Object> posProduct = (Map<String, Object>) product;
            Map<String, Object> curRow = new Map<String, Object>();
            
            curRow.put('item_name', posProduct.get('item_name'));
            curRow.put('retail_price',String.isBlank(posProduct.get('retail_price')+ '') ? '0.00' : posProduct.get('retail_price'));
            curRow.put('pomo_price',String.isBlank(posProduct.get('pomo_price')+ '') ? '0.00' : posProduct.get('pomo_price'));
            curRow.put('most_recent_vendor',posProduct.get('most_recent_vendor'));
            curRow.put('created_by',posProduct.get('created_by'));
            curRow.put('order',String.isBlank(posProduct.get('order')+ '') ? '0' : posProduct.get('order'));
            curRow.put('inventory', String.isBlank(posProduct.get('inventory')+ '') ? '0' : posProduct.get('inventory'));
            curRow.put('adjustment',String.isBlank(posProduct.get('adjustment')+ '') ? '0' : posProduct.get('adjustment'));
            curRow.put('status',posProduct.get('status'));
            curRow.put('sales',String.isBlank(posProduct.get('sales')+ '') ? '0' : posProduct.get('sales'));
            curRow.put('forecast_sales_three_months',String.isBlank(posProduct.get('forecast_sales_three_months')+ '') ? '0' : posProduct.get('forecast_sales_three_months'));
            curRow.put('need_to_order_for_next_three_months',String.isBlank(posProduct.get('need_to_order_for_next_three_months')+ '') ? '0' : posProduct.get('need_to_order_for_next_three_months'));
            curRow.put('annualized_sales',String.isBlank(posProduct.get('annualized_sales')+ '') ? '0' : posProduct.get('annualized_sales'));
            curRow.put('annualized_qty',String.isBlank(posProduct.get('annualized_qty')+ '') ? '0' : posProduct.get('annualized_qty'));
            curRow.put('category',posProduct.get('category'));
            curRow.put('image_url',posProduct.get('image_url'));
            curRow.put('last_edited_by',posProduct.get('last_edited_by'));
            curRow.put('last_cost',String.isBlank(posProduct.get('last_cost')+ '') ? '0' : posProduct.get('last_cost'));
            curRow.put('barcode',posProduct.get('barcode'));
            curRow.put('unit',posProduct.get('unit'));
            curRow.put('created_at',(posProduct.get('created_at') + '').subString(0,10));
            curRow.put('updated_at',(posProduct.get('updated_at') + '').subString(0,10));
            curRow.put('DisplayUrl','https://limitless-fjord-48119.herokuapp.com/api/v1/products/'+posProduct.get('id')); 
            curRow.put('ExternalId', posProduct.get('item_name')+ '' + '-Item-'+posProduct.get('id')); 
            
            //System.debug(curRow);
            lstReturnDataset.add(curRow);
        }
        
        return lstReturnDataset;
    } 
    
}