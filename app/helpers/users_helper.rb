module UsersHelper
  def gravatar_for user,
    options = {default: Settings.development.default_gravatar_size}
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def gender_options
    [
      [t("activerecord.attributes.user.female"), :female],
      [t("activerecord.attributes.user.male"), :male],
      [t("activerecord.attributes.user.other"), :other]
    ]
  end
end
