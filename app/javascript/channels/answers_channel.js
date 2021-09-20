import consumer from "./consumer"

consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
  connected() {
    return this.perform('stream_from');
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $('.answers').append(data);
  }
});
