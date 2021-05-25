import { Controller } from 'stimulus'

export default class extends Controller {
  close(event) {
    this.element.parentNode.removeChild(this.element)
  }

  escClose(event) {
    if (event.key === 'Escape') {
      this.close()
    }
  }

  onPostSuccess(event) {
    console.log("success!")
  }
}
