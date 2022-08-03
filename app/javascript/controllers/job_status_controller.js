import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['output']

  nextPage() {
    this.outputTarget.textContent =
      "YEP!!!"
  }
}
