import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              HugeIcons.strokeRoundedMenu09,
              color: Colors.black87,
            ),
            onPressed: () {},
          ),
          centerTitle: true,
          title: Text(
            l10n.news,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                HugeIcons.strokeRoundedNotification03,
                color: Colors.black87,
              ),
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade200,
                    width: 0.5,
                  ),
                ),
              ),
              child: TabBar(
                isScrollable: true,
                indicatorColor: Colors.black87,
                indicatorWeight: 1,
                labelColor: Colors.black87,
                unselectedLabelColor: Colors.grey.shade600,
                dividerColor: Colors.transparent,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                tabs: [
                  Tab(text: l10n.news),
                  Tab(text: l10n.announcements),
                  Tab(text: l10n.events),
                  Tab(text: l10n.technology),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20.0),
            StoriesBar(l10n: l10n),
            const SizedBox(height: 20.0),
            Expanded(
              child: TabBarView(
                children: [
                  NewsTab(l10n: l10n),
                  Center(
                      child: Text(l10n.announcements,
                          style: const TextStyle(fontSize: 18))),
                  Center(
                      child: Text(l10n.events,
                          style: const TextStyle(fontSize: 18))),
                  Center(
                      child: Text(l10n.technology,
                          style: const TextStyle(fontSize: 18))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsTab extends StatelessWidget {
  final AppLocalizations l10n;

  const NewsTab({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        NewsCard(
          l10n: l10n,
          avatarUrl: 'assets/icons/guest.png',
          userName: 'Мадина',
          timeAgo: l10n.timeAgo1,
          text: l10n.newsContent1,
          imageUrls: const [
            'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
            'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
          ],
          likesCount: 2,
        ),
        NewsCard(
          l10n: l10n,
          avatarUrl: 'assets/icons/guest.png',
          userName: 'Саят',
          timeAgo: l10n.timeAgo2,
          text: l10n.newsContent2,
          imageUrls: const [
            'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
          ],
          likesCount: 5,
        ),
      ],
    );
  }
}

class NewsCard extends StatelessWidget {
  final AppLocalizations l10n;
  final String avatarUrl;
  final String userName;
  final String timeAgo;
  final String text;
  final List<String> imageUrls;
  final int likesCount;

  const NewsCard({
    super.key,
    required this.l10n,
    required this.avatarUrl,
    required this.userName,
    required this.timeAgo,
    required this.text,
    required this.imageUrls,
    required this.likesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(avatarUrl),
                  radius: 18,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          if (imageUrls.isNotEmpty)
            SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        CupertinoIcons.heart,
                        size: 28,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        HugeIcons.strokeRoundedComment02,
                        size: 24,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        HugeIcons.strokeRoundedShare03,
                        size: 24,
                      ),
                      onPressed: () {},
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.bookmark_border, size: 24),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${likesCount.toString()} ${l10n.likes}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: '$userName ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: text),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.viewAllComments,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const ActionButton({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class StoriesBar extends StatelessWidget {
  final AppLocalizations l10n;

  const StoriesBar({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final stories = [
      {'name': l10n.you, 'isAdd': true},
      {
        'name': 'Kristin',
        'avatar': 'https://randomuser.me/api/portraits/women/2.jpg',
        'stories': [
          'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
          'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
        ],
      },
      {
        'name': 'Darrell',
        'avatar': 'https://randomuser.me/api/portraits/men/3.jpg',
        'stories': [
          'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
        ],
      },
      {
        'name': 'Jerome',
        'avatar': 'https://randomuser.me/api/portraits/women/4.jpg',
        'stories': [
          'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
        ],
      },
      {
        'name': 'Sophie',
        'avatar': 'https://randomuser.me/api/portraits/women/5.jpg',
        'stories': [
          'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
        ],
      },
      {
        'name': 'Alex',
        'avatar': 'https://randomuser.me/api/portraits/men/6.jpg'
      },
      {
        'name': 'Lina',
        'avatar': 'https://randomuser.me/api/portraits/women/7.jpg'
      },
      {
        'name': 'Tom',
        'avatar': 'https://randomuser.me/api/portraits/men/8.jpg'
      },
      {
        'name': 'Anna',
        'avatar': 'https://randomuser.me/api/portraits/women/9.jpg'
      },
      {
        'name': 'Mike',
        'avatar': 'https://randomuser.me/api/portraits/men/10.jpg'
      },
      {
        'name': 'Olga',
        'avatar': 'https://randomuser.me/api/portraits/women/11.jpg'
      },
      {
        'name': 'Sam',
        'avatar': 'https://randomuser.me/api/portraits/men/12.jpg'
      },
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      height: 110,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: stories.asMap().entries.map((entry) {
            final i = entry.key;
            final story = entry.value;
            Widget avatarWidget;
            if (story['isAdd'] == true) {
              avatarWidget = Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF23232B),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                  child: Icon(Icons.add, color: Colors.white, size: 36),
                ),
              );
            } else {
              avatarWidget = GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierColor: Colors.black.withOpacity(0.95),
                    builder: (_) => StoryViewer(
                      l10n: l10n,
                      user: story,
                    ),
                  );
                },
                child: Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xFFE95A7B),
                      width: 4,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      story['avatar'] as String,
                      fit: BoxFit.cover,
                      width: 74,
                      height: 74,
                    ),
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  avatarWidget,
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 80,
                    child: Text(
                      story['name'] as String,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class StoryViewer extends StatefulWidget {
  final AppLocalizations l10n;
  final Map<String, Object> user;

  const StoryViewer({required this.l10n, required this.user, super.key});

  @override
  State<StoryViewer> createState() => StoryViewerState();
}

class StoryViewerState extends State<StoryViewer>
    with SingleTickerProviderStateMixin {
  late PageController _controller;
  late int _currentIndex;
  late AnimationController _progressController;

  List<String> get storyItems =>
      (widget.user['stories'] as List).cast<String>();

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _controller = PageController(initialPage: _currentIndex);
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_currentIndex < storyItems.length - 1) {
          setState(() {
            _currentIndex++;
            _controller.animateToPage(_currentIndex,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
            _progressController.forward(from: 0);
          });
        } else {
          Navigator.of(context).pop();
        }
      }
    });
    _progressController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void onPageChanged(int i) {
    setState(() {
      _currentIndex = i;
      _progressController.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Фоновое изображение
          PageView.builder(
            controller: _controller,
            itemCount: storyItems.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, i) {
              return SizedBox.expand(
                child: Image.network(
                  storyItems[i],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          // Верхняя панель с прогресс-баром и иконками
          SafeArea(
            child: Column(
              children: [
                // Прогресс-бар
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: List.generate(storyItems.length, (i) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: LinearProgressIndicator(
                            value: i < _currentIndex
                                ? 1
                                : i == _currentIndex
                                ? _progressController.value
                                : 0,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                            minHeight: 4,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                // Верхние иконки
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(HugeIcons.strokeRoundedArrowLeft02,
                            color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(HugeIcons.strokeRoundedFullScreen,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(
                                HugeIcons.strokeRoundedMoreVerticalCircle01,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}