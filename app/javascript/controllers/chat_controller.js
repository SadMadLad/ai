import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"
import { marked } from "marked";

// Connects to data-controller="chat"
export default class extends Controller {
  static targets = ["submitButton", "form", "input", "message", "container"];
  static values = {
    uuid: { type: String }
  }

  messageTargetConnected(message) {
    message.classList.add("py-2.5", "px-4", "rounded-lg", "border", "prose");
    message.innerHTML = marked.parse(message.innerHTML);
  }

  connect() {
    this.connectChat();
  }

  clear(e) {
    if (e.detail.success) this.inputTarget.value = "";
  }

  connectChat() {
    const controller = this;

    consumer.subscriptions.create({ channel: "TemporaryChatChannel", uuid: this.uuidValue }, {
      initialized() {
        this.streamStarted = false;
        this.newMessage = null;
      },

      received(data) {
        if (!this.streamStarted && !data.done) {
          this.streamStarted = true;
          this.newMessage = document.createElement("div");
          this.newMessage.textContent += data.message

          controller.containerTarget.append(this.newMessage);
        } else {
          this.newMessage.innerHTML += data.message;
          if (data.done) {
            this.newMessage.innerHTML = marked.parse(this.newMessage.innerHTML);
            this.newMessage.dataset.chatTarget = "message";
            this.streamStarted = false;
          }
        }
      }
    });
  }
}
