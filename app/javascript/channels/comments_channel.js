import consumer from "./consumer"

consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
  connected() {
    return this.perform('stream_from');
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    let parsedData = JSON.parse(data);
    let html_content = parsedData.html_content;
    let id = parsedData.comment.commentable_id;
    let type =  parsedData.comment.commentable_type;
    console.log(type)
    if (type == 'Question') {
      $('.question-comments').append(html_content);
    } else {
      $('#answer-comments-' + id).append(html_content);
    }
  }
});
