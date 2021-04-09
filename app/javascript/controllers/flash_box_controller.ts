import { Controller } from 'stimulus'

export default class extends Controller {
  closeBox = () => {
    this.element.parentNode.removeChild(this.element)
  }
}
