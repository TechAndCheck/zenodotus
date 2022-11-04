module Admin::ApplicantsHelper
  def or_na(text)
    text.present? ? text : '<span class="na">n/a</span>'.html_safe
  end
end
