class FirstClickFreeSession
  def initialize session
    key = first_click_free_of_session_key
    if session["first_click_free"].blank? || session["first_click_free"][key].blank?
      session["first_click_free"] = {key => {}}
    end
    @clicks = session["first_click_free"][key]["first_click"] || []
    @session = session
  end

  def clicks
    @clicks
  end

  def clicks=(click)
    add click,  -> c { @clicks = c }
  end

  def <<(click)
    add click, -> c { @clicks << c }
  end

  private
    def add click, operation
      key = first_click_free_of_session_key
      operation.call click
      @session["first_click_free"][key] = {"first_click" => @clicks}
    end

    def first_click_free_of_session_key
      Date.today.strftime("%Y%m%d")
    end
end
