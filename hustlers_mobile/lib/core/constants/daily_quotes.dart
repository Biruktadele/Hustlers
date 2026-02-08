import 'dart:math';

/// Paste your quotes here in the format:
///
///   [["quote", "name"], ...]
///
/// Example:
///   [
///     ["Success is not final...", "Winston Churchill"],
///   ]
const List<List<String>> dailyQuotesRaw = <List<String>>[
  ["The way to get started is to quit talking and begin doing.", "Walt Disney"],
  ["Life is a journey, and sometimes the hardest path leads to the greatest rewards.", "Master Oogway"],
  ["Don’t wait for opportunity. Create it.", "Anonymous"],
  ["While it is always best to believe in oneself, a little help from others can be a great blessing.", "Uncle Iroh"],
  ["No matter how hard the situation, there’s always a way out.", "Hayao Miyazaki"],
  ["Opportunities don’t happen. You create them.", "Chris Grosser"],
  ["Success is not in what you have, but who you are.", "Bo Bennett"],
  ["No matter how small the step you take is, as long as you’re moving forward…", "Erwin Smith"],
  ["It is easy to do nothing, but it is hard to forgive.", "Aang"],
  ["Failure is the condiment that gives success its flavor.", "Truman Capote"],
  ["The key to success is to focus our conscious mind on things we desire, not things we fear.", "Brian Tracy"],
  ["Fall seven times and stand up eight.", "Japanese Proverb"],
  ["Little by little, one travels far.", "J.R.R. Tolkien"],
  ["Motivation is what gets you started. Habit is what keeps you going.", "Jim Ryun"],
  ["If you don’t like your destiny, don’t accept it. Instead, have the courage to change it the way you want it to be.", "Naruto Uzumaki"],
  ["The best way to predict the future is to create it.", "Peter Drucker"],
  ["A lesson without pain is meaningless.", "Edward Elric"],
  ["It always seems impossible until it’s done.", "Nelson Mandela"],
  ["The ticket to the future is always open.", "Vash the Stampede"],
  ["You just need to believe. You must believe.", "Master Oogway"],
  ["Every life is precious, and every choice shapes the future.", "Aang"],
  ["The world isn’t perfect. But it’s there for us, doing the best it can… that’s what makes it so damn beautiful.", "Roy Mustang"],
  ["Life isn’t just doing things for yourself.", "Yui Hirasawa"],
  ["Sometimes the right path is not the easiest one.", "Aang"],
  ["Look at this simple object. What is real? Is it this? Or the idea of it?", "Master Oogway"],
  ["Do one thing every day that scares you.", "Eleanor Roosevelt"],
  ["Stand up and walk. Keep moving forward.", "Edward Elric"],
  ["Don’t watch the clock; do what it does. Keep going.", "Sam Levenson"],
  ["Even if things are painful and tough… appreciate being alive.", "Yato"],
  ["I find that the harder I work, the more luck I seem to have.", "Thomas Jefferson"],
  ["Push yourself because no one else is going to do it for you.", "Anonymous"],
  ["You cannot change what you are, only what you do.", "Alucard"],
  ["It’s not always possible to do what we want to do, but it’s important to believe in something before you actually do it.", "Might Guy"],
  ["To know sorrow is not terrifying.", "Matsumoto Rangiku"],
  ["To make something special, you just have to believe it’s special.", "Master Oogway"],
  ["The strength of a nation derives from the integrity of its people.", "Uncle Iroh"],
  ["Success is not the key to happiness. Happiness is the key to success.", "Albert Schweitzer"],
  ["Push yourself, because no one else is going to do it for you.", "Anonymous"],
  ["When you lose sight of your path, listen for the destination in your heart.", "Jiraiya"],
  ["One often meets his destiny on the road he takes to avoid it.", "Master Oogway"],
  ["Do what you can with all you have, wherever you are.", "Theodore Roosevelt"],
  ["Start where you are. Use what you have. Do what you can.", "Arthur Ashe"],
  ["If you want to change the world, start with yourself.", "Monkey D. Luffy"],
  ["The only place where success comes before work is in the dictionary.", "Vidal Sassoon"],
  ["Success is walking from failure to failure with no loss of enthusiasm.", "Winston Churchill"],
  ["All we can do is live until the day we die.", "Deneil Young"],
  ["Whatever you lose, you’ll find it again. But what you throw away you’ll never get back.", "Kenshin Himura"],
  ["Just because someone is important to you doesn’t mean they are good.", "Mikasa Ackerman"],
  ["Failure is only the opportunity to begin again, this time more intelligently.", "Uncle Iroh"],
  ["Patience and perseverance lead to mastery.", "Po"],
  ["Don’t let yesterday take up too much of today.", "Will Rogers"],
  ["Your real strength comes from being the best ‘you’ you can be.", "Po"],
  ["Simplicity is the easiest path to true beauty.", "Seishuu Handa"],
  ["When we hit our lowest point, we are open to the greatest change.", "Aang"],
  ["Don’t limit your challenges. Challenge your limits.", "Anonymous"],
  ["Happiness is found when you stop comparing yourself to others.", "Po"],
  ["You can die anytime, but living takes true courage.", "Kenshin Himura"],
  ["The more you try to control, the more you lose.", "Master Oogway"],
  ["You will never be able to love anybody else until you love yourself.", "Lelouch Lamperouge"],
  ["Great things never come from comfort zones.", "Anonymous"],
  ["The best revenge is massive success.", "Frank Sinatra"],
  ["There are no accidents.", "Master Oogway"],
  ["Success is not final; failure is not fatal: It is the courage to continue that counts.", "Winston Churchill"],
  ["Don’t be busy, be productive.", "Anonymous"],
  ["Don’t be embarrassed by your failures, learn from them and start again.", "Richard Branson"],
  ["Human strength lies in the ability to change yourself.", "Saitama"],
  ["Big jobs usually go to the men who prove their ability to outgrow small ones.", "Ralph Waldo Emerson"],
  ["Don’t be afraid to give up the good to go for the great.", "John D. Rockefeller"],
  ["The only ones who should kill are those prepared to be killed.", "Lelouch Lamperouge"],
  ["Greatness comes from embracing who you are, not what others expect of you.", "Po"],
  ["Ideas are easy. Implementation is hard.", "Guy Kawasaki"],
  ["You don’t need to be perfect to start, but you need to start to be successful.", "Anonymous"],
  ["Miracles don’t happen by just sitting around.", "Kiyoshi Fujino"],
  ["There’s no shame in falling down! True shame is to not stand up again!", "Shintaro Midorima"],
  ["Yesterday is history, tomorrow is a mystery, but today is a gift. That is why it is called the present.", "Master Oogway"],
  ["If you really look closely, most overnight successes took a long time.", "Steve Jobs"],
  ["If you are not willing to risk the usual, you will have to settle for the ordinary.", "Jim Rohn"],
  ["Your limitation—it’s only your imagination.", "Anonymous"],
  ["Sometimes the best way to solve your own problems is to help someone else.", "Uncle Iroh"],
  ["Balance in all things is the key to a meaningful life.", "Master Oogway"],
  ["The moment you think of giving up, think of the reason why you held on so long.", "Natsu Dragneel"],
  ["The secret of change is to focus all your energy not on fighting the old, but on building the new.", "Socrates"],
  ["Success is liking yourself, liking what you do, and liking how you do it.", "Maya Angelou"],
  ["Everything you’ve ever wanted is on the other side of fear.", "George Addair"],
  ["The secret to happiness lies in letting go of the things you cannot control.", "Po"],
  ["You have to believe in yourself. That’s the secret.", "Po"],
  ["It’s just pathetic to give up before even trying.", "Reiko Mikami"],
  ["It matters not what someone is born, but what they grow to be.", "Master Oogway"],
  ["Believe in yourself. Not in the you who believes in me. Believe in the you who believes in yourself.", "Kamina"],
  ["People’s lives don’t end when they die. It ends when they lose faith.", "Itachi Uchiha"],
  ["What is right? What is wrong? It’s not easy.", "Johan Liebert"],
  ["The true mind can weather all the lies and illusions without being lost.", "Aang"],
  ["In the darkest times, hope is something you give yourself. That is the meaning of inner strength.", "Uncle Iroh"],
  ["Fear is not evil. It tells you what weakness is.", "Gildarts Clive"],
  ["Perfection and power are overrated. I think you are very wise to choose happiness and love.", "Uncle Iroh"],
  ["The only thing that matters is what you choose to be now.", "Po"],
  ["Even if I lose my bending, I’ll never lose who I am.", "Aang"],
  ["Hard work betrays none, but dreams betray many.", "Hachiman Hikigaya"],
  ["It’s not enough to just live. You have to have something to live for.", "Shiroe"],
  ["Don’t give up on your dreams.", "Tetsuro Araki"],
  ["The world is not beautiful, therefore it is.", "Kino"],
  ["It is important to draw wisdom from many sources. If you take it from only one, it becomes rigid and stale.", "Uncle Iroh"],
  ["Destiny. Fate. Dreams… as long as there are people who seek freedom…", "Gol D. Roger"],
  ["Courage is not the absence of fear, but the ability to act in spite of it.", "Po"],
  ["There’s always hope, even in the darkest of times.", "Aang"],
  ["A person can change, at the moment when the person wishes to change.", "Haruhi Fujioka"],
  ["The past is the past. We cannot indulge ourselves in memories and destroy the present.", "Murata Ken"],
  ["We are all like fireworks: we climb, we shine…", "Hitsugaya Toshiro"],
  ["Do not let the noise of others’ opinions drown out your own inner voice.", "Master Oogway"],
  ["No matter how small the step, forward is forward.", "Simon"],
  ["The harder you work for something, the greater you’ll feel when you achieve it.", "Anonymous"],
  ["Your destiny is not written, it is what you choose to make of it.", "Po"],
  ["In order to truly live, you must first be willing to die.", "Ken Kaneki"],
  ["Act as if what you do makes a difference. It does.", "William James"],
  ["Dream big. Start small. Act now.", "Robin Sharma"],
  ["You don’t have to be great to start, but you have to start to be great.", "Zig Ziglar"],
  ["Your past is just a story. And once you realize this, it has no power over you.", "Master Oogway"],
  ["Sometimes to lead others, you must first follow your own heart.", "Uncle Iroh"],
  ["Life happens wherever you are, whether you make it or not.", "Uncle Iroh"],
  ["Justice will prevail, you say? Of course it will!", "Don Quixote Doflamingo"],
  ["The secret of success is to do the common thing uncommonly well.", "John D. Rockefeller Jr."],
  ["Violence isn’t always the answer.", "Aang"],
  ["It’s not what others think of you that matters.", "Meliodas"],
  ["Success usually comes to those who are too busy to be looking for it.", "Henry David Thoreau"],
  ["Sharing tea with a fascinating stranger is one of life’s true delights.", "Uncle Iroh"],
  ["Your mind is like water, my friend. When it is agitated, it becomes difficult to see. But if you allow it to settle, the answer becomes clear.", "Master Oogway"],
  ["We’re not here to fight. We’re here to help.", "Aang"],
  ["Anything is possible when you believe in yourself.", "Po"],
  ["Sometimes we’re tested not to show our weaknesses, but to discover our strengths.", "Anonymous"],
  ["Sometimes life is like this dark tunnel. You can’t always see the light at the end, but if you just keep moving… you will come to a better place.", "Uncle Iroh"],
  ["Knowing what it feels like to be in pain is why we try to be kind.", "Jiraiya"],
  ["True courage is facing danger when you are afraid.", "Aang"],
  ["The difference between ordinary and extraordinary is that little extra.", "Jimmy Johnson"],
  ["In order to move on, you must first let go.", "CLAMP"],
  ["Success is not how high you have climbed, but how you make a positive difference to the world.", "Roy T. Bennett"],
  ["There is no such thing as an impossible dream.", "Leiji Matsumoto"],
  ["The only way to truly escape the mundane is to constantly evolve.", "Izaya Orihara"],
  ["When we let go of fear, we gain freedom.", "Aang"],
  ["Even the smallest step can make the biggest difference.", "Po"],
  ["Peace comes from within. Do not seek it without.", "Aang"],
  ["A goal is a dream with a deadline.", "Napoleon Hill"],
  ["We only have one life to live.", "Yui"],
  ["Opportunities are usually disguised as hard work, so most people don’t recognize them.", "Ann Landers"],
  ["Success seems to be connected with action. Successful people keep moving.", "Conrad Hilton"],
  ["It’s time for you to look inward and begin asking yourself the big questions: Who are you? And what do you want?", "Uncle Iroh"],
  ["I’m not a big fat panda, I’m THE big fat panda.", "Po"],
  ["Believe in yourself and create your own destiny.", "Naruto Uzumaki"],
  ["Yesterday’s mistakes are lessons, not shackles.", "Master Oogway"],
  ["No matter how deep the night, it always turns to day, eventually.", "Brook"],
];

class DailyQuote {
  final String quote;
  final String author;

  const DailyQuote(this.quote, this.author);
}

final List<DailyQuote> dailyQuotes = dailyQuotesRaw
    .map((q) => DailyQuote(q[0], q[1]))
    .toList(growable: false);

/// Emits a new quote every [interval] (default: 12 hours).
/// Cancel the subscription (or stop listening) to stop the rotation.
Stream<DailyQuote> dailyQuoteRotationStream({
  Duration interval = const Duration(hours: 12),
  bool shuffle = false,
  int? seed,
}) async* {
  final quotes = List<DailyQuote>.of(dailyQuotes);
  if (quotes.isEmpty) return;

  if (shuffle) {
    quotes.shuffle(Random(seed));
  }

  var i = 0;
  while (true) {
    yield quotes[i % quotes.length];
    i++;
    await Future<void>.delayed(interval);
  }
}

/// Deterministic selection: changes quote every [interval] based on time.
DailyQuote quoteForTimestamp(
  DateTime timestamp, {
  Duration interval = const Duration(hours: 12),
}) {
  if (dailyQuotes.isEmpty) {
    throw StateError('dailyQuotes is empty');
  }
  final slot = timestamp.millisecondsSinceEpoch ~/ interval.inMilliseconds;
  return dailyQuotes[slot % dailyQuotes.length];
}
