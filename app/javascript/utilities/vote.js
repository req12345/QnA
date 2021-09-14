$(document).on('turbolinks:load', function(){
    $('.vote').on('ajax:success', function(e) {
        var detail = e.detail[0];
        var rating = detail.rating;
        var resourceName =  detail.resource_name;
        var resourceId = detail.resource_id;

        $('#rating-' + resourceName + '-' + resourceId).html('Rating: ' + rating)
    })
});
