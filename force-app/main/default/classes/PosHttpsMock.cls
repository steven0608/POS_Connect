@isTest
global class PosHttpsMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('GET', req.getMethod());
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"id": 26, "item_name": "pineapple", "retail_price": "4.99", "pomo_price": "2.99", "most_recent_vendor": "Steven","created_by": "admin", "order": "50", "inventory": "11","adjustment": "0", "status": "active","sales": "39", "forecast_sales_three_months": "2","need_to_order_for_next_three_months": "1","annualized_sales": "100","annualized_qty": "5","category": "Produce","image_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSb-zeyfb4mCJNyVbIxF9BWVGy1WoOnCL2ykPiXIjMY92QYsGqL","last_edited_by": "admin","last_cost": "3.0","barcode": 4,"unit": "lb","created_at": "2018-08-22T17:47:35.461Z","updated_at": "2019-04-29T14:10:27.737Z"}]');
        res.setStatusCode(200);
        return res;
    }
}