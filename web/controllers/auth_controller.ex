defmodule UeberauthExample.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """
  use UeberauthExample.Web, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias UeberauthExample.XMLParser

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserFromAuth.find_or_create(auth) do
      {:ok, user  } ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user)
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  def import(conn, params) do
    url = full_url(params["code"])

    access_data =
      url
      |> exchange_tokens
      |> decode_data

    access_token = access_data["access_token"]

    headers =
      access_token
      |> build_headers

    content =
      headers
      |> final_auth_token
      |> XMLParser.fetch

    json conn, %{request: content}
  end

  defp build_headers(token) do
    [{"Gdata-Version", "3.0"}, {"Authorization", "Bearer #{token}"}]
  end

  defp exchange_tokens(url) do
    HTTPoison.request!(:post, endpoint, url, [{"content-type", "application/x-www-form-urlencoded"}])
  end

  defp final_auth_token(headers) do
    HTTPoison.request!(:get, "https://www.google.com/m8/feeds/contacts/default/full", "", headers)
  end

  defp decode_data(%{body: body}=data) do
    Poison.decode!(body)
  end

  defp full_url(token) do
    "code=#{token}"
    <>"&redirect_uri=#{redirect_url}"
    <>"&client_id=#{client_id}"
    <>"&client_secret=#{client_secret}"
    <>"&scope=&grant_type=authorization_code"
  end

  defp endpoint,      do: "https://www.googleapis.com/oauth2/v3/token"
  defp client_id,     do: System.get_env("GOOGLE_CLIENT_ID")
  defp client_secret, do: System.get_env("GOOGLE_CLIENT_SECRET")
  defp redirect_url,  do: "#{UeberauthExample.Endpoint.static_url}/auth/google/import"
end
