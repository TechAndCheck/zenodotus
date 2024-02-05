import { Controller } from '@hotwired/stimulus'
import { humanizeTimeElement } from 'utilities'

export default class extends Controller {
  static targets = [
    'timestamp',
    'captionContent',
    'captionToggler',
    'filterWrapper',
    'filterWrapperToggle',
    'organizationFilter',
    'fromDateFilter',
    'toDateFilter'
  ]

  static values = { captionCollapseMode: String }

  timestampTargetConnected(element) {
    humanizeTimeElement(element)
  }

  toggleCaption() {
    switch (this.captionCollapseModeValue) {
      case 'collapsed':
        this.captionCollapseModeValue = 'expanded'
        this.captionTogglerTarget.innerText = this.captionTogglerTarget.dataset.collapseLabel
        break
      case 'expanded':
        this.captionCollapseModeValue = 'collapsed'
        this.captionTogglerTarget.innerText = this.captionTogglerTarget.dataset.expandLabel
        break
      default:
        // This doesn't break anything for users, but we developers would want to know.
        // eslint-disable-next-line no-console
        console.error('media-vault--archive#toggleCaption called unexpectedly.')
    }
  }

  showFilters() {
    if(this.filterWrapperTarget.classList.contains("hidden")) {
      this.filterWrapperTarget.classList.remove('hidden') 
        this.filterWrapperToggleTarget.innerHTML = 'Hide Filters &nbsp;&nbsp;<span style="font-size: 0.5em">▲</span>'
    } else {
      this.filterWrapperTarget.classList.add('hidden')
      this.filterWrapperToggleTarget.innerHTML = 'Show Filters &nbsp;&nbsp;<span style="font-size: 0.5em">▼</span>'
    }
  }

  clearFilters() {
    this.organizationFilterTarget.value = ''
    this.fromDateFilterTarget.value = ''
    this.toDateFilterTarget.value = ''
    window.location = '/dashboard'
  }

  filterResults() {
    let orgValue = this.organizationFilterTarget.value
    console.log('filterResultsByOrganization called for ' + orgValue)

    let fromDateValue = this.fromDateFilterTarget.value
    console.log('fromDateValue: ' + fromDateValue)

    let toDateValue = this.toDateFilterTarget.value
    console.log('toDateValue: ' + toDateValue)

    if(!orgValue && !fromDateValue && !toDateValue) {
      return
    }

    var url = '/dashboard?'
    if (orgValue) {
      url += 'organization_id=' + orgValue
    }
    if (fromDateValue) {
      url += '&from_date=' + fromDateValue
    }
    if (toDateValue) {
      url += '&to_date=' + toDateValue
    }
    window.location = url
  }
}
