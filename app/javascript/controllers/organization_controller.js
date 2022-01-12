import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    eventId: String,
    userId: String
  }

  setUserAsAdmin(event) {
    let body = JSON.stringify({
              event_id: this.eventId,
              user_id: this.userId
            })
    fetch('/organizations/update_admin', { method: 'PUT', body: body })
      .then(response => response.text())
      .then(html => this.element.innerHTML = html)
  }

  close() {
    if (this.element && this.element.parentNode) {
      this.element.parentNode.removeChild(this.element)
    }
  }

  escClose(event) {
    if (event.key === 'Escape') {
      this.close()
    }
  }

  onPostSend() {
    const loader = document.getElementById('loader')
    if (loader !== null) {
      loader.classList.remove('hidden')
    }
  }

  onPostSuccess() {
    console.log('success!')
  }
}
