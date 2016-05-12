defmodule UeberauthExample.PageView do
  @moduledoc false

  use UeberauthExample.Web, :view

  @doc """
  builds the redirect url and link.
  """
  def google_redirect_url do
    client_id = System.get_env("ORION_GOOGLE_CLIENT_ID")

    "https://accounts.google.com/o/oauth2/auth?"
    <>"redirect_uri=#{UeberauthExample.Endpoint.static_url}/auth/google/import"
    <>"&response_type=code&client_id=#{client_id}"
    <>"&scope=https://www.google.com/m8/feeds/&approval_prompt=force&access_type=offline"
  end
end
