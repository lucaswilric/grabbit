	$(function(){
    SubdomainSettingsMap = {
      'reading': {title: "Lucas's Reading List", showSubscription: true},
      'links': {title: "Lucas's Linkblog", showSubscription: false},
      'grabbit': {title: "Grabbit", showSubscription: true}
    };
	  window.RoN = {
	  months: ['January','February','March','April','May','June','July','August','September','October','November','December'],
	  dateHeading: '',
	  tag: '',
		sourceURL: '/download_jobs/tagged/{TAG}/feed',
		maxItemsToDisplay: 100,
		subscriptions: [],
		addItems: function(items) {
		  $.each(items.reverse(), function() {
		    if ($('#ronItem_' + this.id).length) return;
				
		    newItem = $('#itemTemplate').clone().attr('id', 'ronItem_'+this.id);
		    RoN.fillTemplate(newItem, this);
			  newItem.prependTo('#news');
		    
		    var d = new Date(this.created_at);
		    var newDateHeading = d.getDate() + ' ' + RoN.months[d.getMonth()];
		    
		    if (RoN.dateHeading.indexOf(newDateHeading) != 0) {
		    	RoN.insertDateHeader();
					RoN.dateHeading = newDateHeading;
				}
			});
			RoN.insertDateHeader();
		},
		insertDateHeader: function() {
			if (RoN.dateHeading == '') return;
		
			var header = $('#dateHeaderTemplate').clone().attr('id', null);
			header.find('h2').text(RoN.dateHeading);
			header.prependTo('#news');		
		},
		fillTemplate: function(item, data) {
			  item.find('h3 a'
			    ).attr('href', data.url
			    ).attr('title', data.title
			    ).attr('target', '_blank'
			    ).text(data.title);
			  var domain = data.url.match(/:\/\/([^\/]+)/)[1];
			  item.find('img'
			  	).attr('src', 'http://www.google.com/s2/favicons?domain='+domain);

			  if (SubdomainSettingsMap[RoN.tag].showSubscription)
					item.find('.link-attribution em'
						).text(RoN.subscriptions[data.subscription_id].title); 
				else
					item.find('.link-attribution').remove();
		},
		getNewItems: function() {
		  console.log('Getting new items...');
		  $.ajax({
			url: RoN.sourceURL.replace('{TAG}', RoN.tag),
			success: this.addItems,
			dataType: 'json'
		  });
		  console.log('Done getting new items.');
		},
		removeOldItems: function() {},
		getSubscriptions: function() {
			$.ajax({
			url: 'subscriptions/tagged/{TAG}.json'.replace('{TAG}', RoN.tag),
			success: function(data) { $.each(data, function() {
				RoN.subscriptions[this.id] = this;
			}) },
			dataType: 'json'
		  });
		},
    startEverything: function() {
      var t = location.href.match(/:\/\/([^\.])+[\.\/]/)[0];
		  this.tag = t.substr(3,t.length-4);
      $('.page-header h1').text(SubdomainSettingsMap[this.tag].title);
      $('#rss-icon').attr('href', 'download_jobs/tagged/'+this.tag+'/feed.rss');
      document.title = SubdomainSettingsMap[this.tag];
      this.getSubscriptions();
      this.getNewItems();
    }
	  };
	  RoN.startEverything();
	});
	