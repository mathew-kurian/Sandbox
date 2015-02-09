var processor = include('processor');

var words = [ 'ABBA','AC/DC', 'Adams Bryan', 'Adele', 'Aguilera Christina', 'Armstrong Louis', 'Bach Johann Sebastian', 'Beach Boys The', 'Beatles The ', 'Beethoven Ludwig van', 'Bieber Justin', 'Black Eyed Peas The', 'Bon Jovi', 'Boublil Alain', 'Bowie David', 'Brickman Jim', 'Brooklyn Tabernacle Choir', 'Browne Jackson', 'Buble Michael', 'Canadian Brass The', 'Cannon Karen', 'Carey Mariah', 'Carpenters The', 'Cash Johnny', 'Chapman Steven Curtis', 'Clapton Eric', 'Clarkson Kelly', 'Clash The', 'Coldplay', 'Creedence Clearwater Revival', 'Crow Sheryl', 'Crowns Casting', 'Cyrus Miley', 'Davis Miles', 'Denver John', 'Dion Celine', 'Dylan Bob', 'Earth Wind and Fire', 'Ellington Duke', 'Fleetwood Mac', 'Folk Song Irish', 'Glee Cast', 'Grateful Dead The', 'Groban Josh', 'Hendrix Jimi', 'Houston Whitney', 'Jackson Michael', 'Joel Billy', 'John Elton', 'Johnson Jack', 'Johnson Robert', 'Jonas Brothers', 'Kern Jerome', 'Lady Gaga', 'Lennon John', 'Lloyd Webber Andrew', 'Mancini Henry', 'Mannheim Steamroller', 'Maroon 5', 'Mars Bruno', 'Martin Dean', 'Mayer John', 'McCartney Paul', 'Menken Alan', 'Metallica', 'Mozart Wolfgang Amadeus', 'Oasis', 'One Direction', 'Perry Katy', 'Presley Elvis', 'Queen', 'Rascal Flatts', 'Red Hot Chili Peppers The', 'Rodgers & Hammerstein', 'Rodgers and Hart', 'Rolling Stones The', 'Satriani Joe', 'Schonberg Claude-Michel', 'Schwartz Stephen', 'Simon And Garfunkel', 'Simon Paul', 'Sinatra Frank', 'Smith Michael W.', 'Smiths The', 'Sondheim Stephen', 'Steely Dan', 'Stereophonics', 'Stevens Cat', 'Sting', 'Swift Taylor', 'Tchaikovsky Peter Ilyich', 'Traditional', 'Travis', 'U2', 'Van Morrison', 'Who The', 'Williams Hank', 'Williams Robbie', 'Withers Bill' ];

var query = String.format("%s", words[Math.floor(Math.random() * words.length)]).toLowerCase();

exports.run = function(){
    processor.find(query, function(err, msg, set){
        console.log(arguments);
    });
} 