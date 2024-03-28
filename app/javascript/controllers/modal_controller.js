import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
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

  // onPostSend() {
  //   const loader = document.getElementById('loader')
  //   if (loader !== null) {
  //     loader.classList.remove('hidden')
  //   }
  // }
}
