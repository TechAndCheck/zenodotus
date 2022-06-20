import consumer from './consumer'

/*
 * Clears old contents of the job table HTML element
 */
function clearJobsTable(jobsTableBody) {
  while (jobsTableBody.firstChild) {
    jobsTableBody.removeChild(jobsTableBody.firstChild)
  }
}

/*
 * Updates the jobs table with new data from ActionCable
 */
function updateJobsTable(jobsTableBody, data, jobAttributes) {
  data.jobs.forEach((job) => {
    const row = document.createElement('tr')
    row.classList.add('border', 'text-gray-600', 'text-center')

    jobAttributes.forEach((attr) => {
      const rowCell = document.createElement('td')
      rowCell.appendChild(document.createTextNode(job[attr]))
      rowCell.classList.add('border')
      row.appendChild(rowCell)
    })
    jobsTableBody.appendChild(row)
  })
}

/*
 * Refreshes old data in the jobs table with new data from ActionCable
 */
function refreshJobsTable(data) {
  const jobsTableBody = document.getElementById('jobs-table-body')
  const jobAttributes = ['queue_position', 'enqueued_at', 'url']
  clearJobsTable(jobsTableBody)
  updateJobsTable(jobsTableBody, data, jobAttributes)
}

consumer.subscriptions.create('JobsChannel', {
  connected() {},

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    refreshJobsTable(data)
  },
})
