class Helpers

  def self.current_user(session)
    @stylist = Stylist.find(session[:stylist_id])
  end

  def self.is_logged_in?(session)
    !session[:stylist_id].nil?
  end

end
