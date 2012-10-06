GOOGLE_URL = 'https://ajax.googleapis.com/ajax/services/search/news?v=1.0' +
  '&callback=?'

$results = $( '.results' ).first()

getDateString = ( date ) ->
  date = new Date Date.parse date
  year = date.getFullYear()
  # lol zero-indexed things
  month = date.getMonth() + 1
  day = date.getDate() + 1
  if Number(month) < 10 then month = '0' + month
  if Number(day) < 10 then day = '0' + day
  "#{year}/#{month}/#{day}"

createResultEl = ( result ) ->
  $root = $ "<article></article>"
  if result.image?
    img = result.image.tbUrl
  else
    img = 'http://placekitten.com/80/60'
  $img = $ "<img src='#{img}'/>"
  url = result.unescapedUrl
  $summary = $ "<p class='info'></p>"
  $publisher = $ "<span class='publisher'>#{result.publisher}</p>"
  date = getDateString result.publishedDate
  $date = $ "<time>#{date}</time>"
  $content = $ """
  <p class='summary'>#{ result.content }
    <a href='#{url}'>Read More</a>
  </p>
  """
  $summary.append( $img, $publisher, $date )
  $title = $ "<h3><a href='#{url}'>#{ result.title }</h3></a>"
  $root.append $title, $summary, $content

displayResults = ( data ) ->
  $results.removeClass 'loading'
  results = data.responseData.results
  if results.length == 0
    $sorryBroResponse = $ """
    <h1 class='error'>Sorry bro, no search results found. :[</h1>
    """
    return $results.append( $sorryBroResponse )
  results.forEach ( result ) ->
    $article = createResultEl result
    $results.append $article

requestData = ( event ) ->
  event.preventDefault()
  $results.empty()
  $results.addClass 'loading'
  query = $( 'input[name="query"]' ).val()
  $.getJSON( GOOGLE_URL,
    { q: query }
    displayResults
  )

$( 'form[name="search"]' ).submit( requestData )
