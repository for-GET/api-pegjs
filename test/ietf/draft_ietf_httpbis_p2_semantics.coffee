{
  should
} = require '../_utils'
httpbis_p2 = require '../../src/ietf/draft_ietf_httpbis_p2_semantics'

describe.skip 'draft_ietf_httpbis_p2_semantics', () ->

  describe 'Accept', () ->
    it 'should parse common Accept headers', () ->
      a = httpbis_p2.Accept('*/*;charset=utf-8;test=test;q=0.1')
      console.error JSON.stringify a, null, 2


  describe 'Accept_Charset', () ->
    it 'should parse common Accept-Charset headers', () ->
      a = httpbis_p2.Accept_Charset('*;q=0.1')
      console.error JSON.stringify a, null, 2


  describe 'Accept_Encoding', () ->
    it 'should parse common Accept-Encoding headers', () ->
      a = httpbis_p2.Accept_Encoding('deflate;q=0.1')
      console.error JSON.stringify a, null, 2


  describe 'Accept_Language', () ->
    it 'should parse common Accept-Language headers', () ->
      a = httpbis_p2.Accept_Language('de-de;q=0.1')
      console.error JSON.stringify a, null, 2


  describe 'Referer', () ->
    it 'should parse common Referer headers', () ->
      a = httpbis_p2.Referer('http://google.com/qwe')
      console.error JSON.stringify a, null, 2


  describe 'User_Agent', () ->
    it 'should parse common User-Agent headers', () ->
      a = httpbis_p2.User_Agent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.65 Safari/537.31')
      console.error JSON.stringify a, null, 2


  describe 'Date', () ->
    it 'should parse common Date headers', () ->
      a = httpbis_p2.Date('Thu, 06 May 2013 15:15:24 GMT')
      console.error JSON.stringify a, null, 2
