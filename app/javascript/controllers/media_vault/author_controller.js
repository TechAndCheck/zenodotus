import { Controller } from '@hotwired/stimulus'
import { humanizeTimeElement } from '../../utilities'

export default class extends Controller {
  static targets = [
    'timestamp',
  ]

  timestampTargetConnected(element) {
    humanizeTimeElement(element)
  }
}
