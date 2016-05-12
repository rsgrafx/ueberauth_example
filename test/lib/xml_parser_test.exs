defmodule UeberauthExample.XMLParserTest do
  use ExUnit.Case, async: true

  require IEx
  alias UeberauthExample.XMLParser

  def sample_google_xml do
  """
  <?xml version="1.0" encoding="UTF-8"?>
  <ns0:feed xmlns:ns0="http://www.w3.org/2005/Atom" xmlns:ns1="http://a9.com/-/spec/opensearchrss/1.0/" xmlns:ns2="http://schemas.google.com/g/2005">
    <ns0:id>myemail@gmail.com</ns0:id>
    <ns0:updated>2016-05-11T11:29:57.678Z</ns0:updated>
    <ns0:category scheme="http://schemas.google.com/g/2005#kind" term="http://schemas.google.com/contact/2008#contact" />
    <ns0:title type="text">Some Random Data</ns0:title>
    <ns0:link href="https://www.google.com/" rel="alternate" type="text/html" />
    <ns0:link href="https://www.google.com/m8/feeds/contacts/myemail%40gmail.com/full" rel="http://schemas.google.com/g/2005#feed" type="application/atom+xml" />
    <ns0:link href="https://www.google.com/m8/feeds/contacts/myemail%40gmail.com/full" rel="http://schemas.google.com/g/2005#post" type="application/atom+xml" />
    <ns0:link href="https://www.google.com/m8/feeds/contacts/myemail%40gmail.com/full/batch" rel="http://schemas.google.com/g/2005#batch" type="application/atom+xml" />
    <ns0:link href="https://www.google.com/m8/feeds/contacts/myemail%40gmail.com/full?max-results=25" rel="self" type="application/atom+xml" />
    <ns0:author>
        <ns0:name>MYname Lastname</ns0:name>
        <ns0:email>myemail@gmail.com</ns0:email>
    </ns0:author>
    <ns0:generator uri="http://www.google.com/m8/feeds" version="1.0">Contacts</ns0:generator>
    <ns1:totalResults>1</ns1:totalResults>
    <ns1:startIndex>1</ns1:startIndex>
    <ns1:itemsPerPage>25</ns1:itemsPerPage>
    <ns0:entry>
        <ns0:id>http://www.google.com/m8/feeds/contacts/myemail%40gmail.com/base/781369628fa94f8b</ns0:id>
        <ns0:updated>2016-03-12T01:05:17.174Z</ns0:updated>
        <ns0:category scheme="http://schemas.google.com/g/2005#kind" term="http://schemas.google.com/contact/2008#contact" />
        <ns0:title type="text" />
        <ns0:link href="https://www.google.com/m8/feeds/photos/media/myemail%40gmail.com/781369628fa94f8b/1B2M2Y8AsgTpgAmY7PhCfg" rel="http://schemas.google.com/contacts/2008/rel#edit-photo" type="image/*" />
        <ns0:link href="https://www.google.com/m8/feeds/contacts/myemail%40gmail.com/full/781369628fa94f8b" rel="self" type="application/atom+xml" />
        <ns0:link href="https://www.google.com/m8/feeds/contacts/myemail%40gmail.com/full/781369628fa94f8b/1457744717174001" rel="edit" type="application/atom+xml" />
        <ns2:email address="foobarjazz@yahoo.com" primary="true" rel="http://schemas.google.com/g/2005#other" />
    </ns0:entry>
</ns0:feed>
  """
  end

  test "parse potential data." do
    assert is_binary(sample_google_xml)
    tuple_result = XMLParser.scan_text(sample_google_xml)
    assert is_tuple(tuple_result)
    entry_list = XMLParser.parse(tuple_result)
    assert is_list( entry_list )
  end

end
