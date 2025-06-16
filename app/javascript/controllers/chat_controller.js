import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

// Connects to data-controller="chat"
export default class extends Controller {
  static targets = ["submitButton", "form", "input", "message", "container"];
  static values = {
    uuid: { type: String }
  }

  connect() {
    this.connectChat();
  }

  clear(e) {
    if (e.detail.success) this.inputTarget.value = "";
  }

  connectChat() {
    const controller = this;

    consumer.subscriptions.create({ channel: "TemporaryChannel", uuid: this.uuidValue }, {
      connected() {
      },

      received(data) {
        console.log('data', data)
      }
    });
  }
}
