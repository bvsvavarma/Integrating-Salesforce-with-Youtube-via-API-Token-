public  class YoutubeController {
    public String body {set;get;}
    public String searchQuery{set;get;}
    public SuperItemList[] dataList{set;get;}//collection of SuperItemList
    //YouTube Search API -> https://developers.google.com/youtube/v3/docs/search/list
    
    public void search(){
        
        dataList = new SuperItemList[]{};
        String sanitizedSearchQuery = searchQuery.replaceAll(' ', '+'); // replacing space with + symbol 
        String apikey = API_TokenController.API_Key;
        //String endPoint = 'https://youtube.googleapis.com/youtube/v3/search?part=snippet&q='+sanitizedSearchQuery+'&key=' + apikey;
        // Named Credential Youtube
        String endPoint = 'callout:Youtube?part=snippet&q='+sanitizedSearchQuery+'&key=' + apikey;
        // Step1: Instantiate HTTP class
        Http http = new Http();
        
        // Step2: Instantiate HTTP Request class and frame the request
        HttpRequest request = new HttpRequest();
        request.setHeader('Accept', 'application/json');
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        // Step3: Send the request and handle the response
        HttpResponse response = http.send(request);
        body = response.getBody(); 
       //Desirializing JSON
       fromJSON d = (fromJSON) JSON.deserialize(body, fromJSON.class);
       //push values to constructor
        for(Integer i =0; i < d.items.size(); i++){
            dataList.add(new SuperItemList(d.items[i].snippet.title,
                                          d.items[i].snippet.description,
                                          d.items[i].snippet.thumbnails.high.url,
                                          d.items[i].snippet.publishTime));
        }
        system.debug(dataList);
    }
   
    public class SuperItemList{
        public String title {set;get;}
        public String descrption {set;get;}
        public String url {set;get;}
        public String publishTime {set;get;}
        
        public SuperItemList(String title, String descrption, String url, String publishTime){
            this.title = title;
            this.descrption = descrption;
            this.url = url;
            this.publishTime = publishTime;
        }
    }
    
    //Covert JSON to APEX using https://www.adminbooster.com/tool/json2apex
	//Inner class in Apex can have 1 level deeper.
	public class fromJSON{
        public String kind;	//youtube#searchListResponse
        public String etag;	//9Tlelvycwy6RXfoVWt1Sxg6WATk
        public String nextPageToken;	//CAUQAA
        public String regionCode;	//US
        public cls_pageInfo pageInfo;
        public cls_items[] items;
	}
    
    class cls_pageInfo {
    	public Integer totalResults;	//1000000
        public Integer resultsPerPage;	//5
    }
    
    class cls_items {
		public String kind;	
		public String etag;	
		public cls_id id;
		public cls_snippet snippet;
	}
	class cls_id {
		public String kind;	
		public String channelId;	
	}
	class cls_snippet {
		public String publishedAt;	
		public String channelId;	
		public String title;	
		public String description;	
		public cls_thumbnails thumbnails;
		public String channelTitle;	
		public String liveBroadcastContent;	
		public String publishTime;	
	}
    
    class cls_thumbnails {
		public cls_default default_x;
		public cls_medium medium;
		public cls_high high;
	}
    
    class cls_default {
		public String url;	
	}
    
    class cls_medium {
		public String url;	
	}
    
    class cls_high {
		public String url;	
	}
    
    
    
}