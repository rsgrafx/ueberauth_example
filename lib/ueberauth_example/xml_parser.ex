defmodule UeberauthExample.XMLParser do

  def fetch(%HTTPoison.Response{body: body}) do
    body
    |> scan_text
    |> parse
  end

  def scan_text(text) do
    :xmerl_scan.string(String.to_char_list(text))
  end

  def parse({xml, _}) do
    emails = :xmerl_xpath.string('/feed//entry/gd:email/@address', xml)
    Enum.reduce(
      emails,
      [],
      fn(email, acc) ->
        e = email |> Tuple.to_list |> Enum.at(8) |> to_string
        acc ++ [e]
      end
    )
  end

end
