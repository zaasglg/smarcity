import 'package:flutter/material.dart';

// Модельдер
class Course {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<CourseLesson> lessons;
  final String category;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.lessons,
    required this.category,
  });
}

class CourseLesson {
  final String title;
  final String content;
  final List<String> images;

  CourseLesson({
    required this.title,
    required this.content,
    required this.images,
  });
}

class EduPage extends StatefulWidget {
  const EduPage({Key? key}) : super(key: key);

  @override
  _EduPageState createState() => _EduPageState();
}

class _EduPageState extends State<EduPage> {
  String _searchQuery = '';
  String _selectedCategory = 'Барлығы';
  final List<String> _categories = [
    'Барлығы',
    'Тұрмыс',
    'Бизнес',
    'Денсаулық',
    'Қауіпсіздік',
  ];

  final List<Course> _courses = [
    Course(
      id: '1',
      title: 'Суды үнемді пайдалану',
      description:
          'Үй тұрмысында және күнделікті өмірде су ресурстарын үнемді пайдалану жолдары.',
      imageUrl: 'assets/images/water_saving.jpg',
      category: 'Тұрмыс',
      lessons: [
        CourseLesson(
          title: 'Суды үнемдеудің маңыздылығы',
          content:
              'Су - өмірдің қайнар көзі. Жер бетіндегі таза су қорының шектеулі екені белгілі. Сондықтан, суды үнемді пайдалану - әрбір адамның міндеті. Бұл бөлімде суды үнемдеудің экологиялық және экономикалық маңыздылығын қарастырамыз.',
          images: ['assets/images/water_importance.jpg'],
        ),
        CourseLesson(
          title: 'Үйдегі су үнемдеу әдістері',
          content:
              'Үй тұрмысында суды үнемдеудің бірнеше жолдары бар: су шүмегін дұрыс пайдалану, су жіберетін құбырларды тексеру, суды қайта қолдану және т.б.',
          images: [
            'assets/images/water_home_tips.jpg',
            'assets/images/water_reuse.jpg'
          ],
        ),
      ],
    ),
    Course(
      id: '2',
      title: 'Шағын бизнес ашу және дамыту',
      description:
          'Шағын бизнесті бастау, жоспарлау және табысты дамытудың негізгі қадамдары.',
      imageUrl: 'assets/images/small_business.jpg',
      category: 'Бизнес',
      lessons: [
        CourseLesson(
          title: 'Бизнес идеясын таңдау',
          content:
              'Табысты бизнес ашу үшін алдымен идея қажет. Бұл бөлімде идеяны қалай таңдау керектігін және оның нарықтағы потенциалын қалай бағалау керектігін үйренесіз.',
          images: ['assets/images/business_idea.jpg'],
        ),
        CourseLesson(
          title: 'Бизнес-жоспар құру',
          content:
              'Бизнес-жоспар - кез келген бизнестің негізі. Жақсы жоспар бизнесіңіздің мақсаттарын, стратегиясын және қаржылық болжамдарын анықтайды.',
          images: ['assets/images/business_plan.jpg'],
        ),
      ],
    ),
    Course(
      id: '3',
      title: 'Дұрыс тамақтану',
      description:
          'Денсаулықты сақтау үшін дұрыс тамақтану негіздері және дәрумендер маңызы.',
      imageUrl: 'assets/images/healthy_eating.jpg',
      category: 'Денсаулық',
      lessons: [
        CourseLesson(
          title: 'Теңгерімді тамақтану принциптері',
          content:
              'Денсаулықты сақтау үшін теңгерімді тамақтану өте маңызды. Бұл бөлімде дұрыс тамақтанудың негізгі қағидаларын үйренесіз: ақуыздар, майлар және көмірсулар арасындағы теңгерім, дәрумендер мен минералдардың маңызы.',
          images: ['assets/images/balanced_diet.jpg'],
        ),
        CourseLesson(
          title: 'Пайдалы тағамдар тізімі',
          content:
              'Күнделікті рационыңызға қосуға пайдалы тағамдар: жемістер, көкөністер, жаңғақтар, толық дәнді өнімдер және т.б.',
          images: [
            'assets/images/healthy_foods.jpg',
            'assets/images/fruits_vegetables.jpg'
          ],
        ),
      ],
    ),
    Course(
      id: '4',
      title: 'Алғашқы көмек көрсету',
      description:
          'Төтенше жағдайларда алғашқы көмек көрсету бойынша нұсқаулар мен тәжірибелер.',
      imageUrl: 'assets/images/first_aid.jpg',
      category: 'Денсаулық',
      lessons: [
        CourseLesson(
          title: 'Алғашқы көмектің негізгі принциптері',
          content:
              'Алғашқы көмек көрсетудің негізгі қадамдары: қауіпсіздікті қамтамасыз ету, көмек шақыру және зардап шеккен адамға көмектесу.',
          images: ['assets/images/first_aid_basics.jpg'],
        ),
        CourseLesson(
          title: 'ЖүрекУөкпе реанимациясы (ЖӨР)',
          content:
              'ЖӨР жүргізу қадамдары: қол орналастыру, қысым күші және жиілігі, дем беру техникасы.',
          images: [
            'assets/images/cpr_technique.jpg',
            'assets/images/cpr_steps.jpg'
          ],
        ),
      ],
    ),
    Course(
      id: '5',
      title: 'Интернет алаяқтығынан қорғану',
      description:
          'Онлайн қауіпсіздік және интернеттегі алаяқтықтан қорғану әдістері.',
      imageUrl: 'assets/images/internet_security.jpg',
      category: 'Қауіпсіздік',
      lessons: [
        CourseLesson(
          title: 'Интернет алаяқтық түрлері',
          content:
              'Фишинг, құпия сөздерді ұрлау, жалған сайттар, әлеуметтік инженерия және басқа да интернет алаяқтық түрлерін үйреніңіз.',
          images: ['assets/images/phishing.jpg'],
        ),
        CourseLesson(
          title: 'Қорғану шаралары',
          content:
              'Күрделі құпия сөздерді қолдану, екі факторлы аутентификация, сенімді антивирустарды пайдалану және күмәнді хабарламаларға жауап бермеу сияқты қорғану шаралары.',
          images: [
            'assets/images/security_measures.jpg',
            'assets/images/two_factor.jpg'
          ],
        ),
      ],
    ),
  ];

  List<Course> get _filteredCourses {
    List<Course> filtered = _courses;

    // Категория бойынша фильтрация
    if (_selectedCategory != 'Барлығы') {
      filtered = filtered
          .where((course) => course.category == _selectedCategory)
          .toList();
    }

    // Іздеу сұранысы бойынша фильтрация
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((course) =>
              course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              course.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Оқыту орталығы'.toUpperCase(),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryFilter(),
          Expanded(
            child: _filteredCourses.isEmpty
                ? _buildEmptyState()
                : _buildCoursesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Курс іздеу...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon:
              Icon(Icons.search, color: const Color(0xFFDB5B2B), size: 20),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFDB5B2B) : Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: isSelected
                        ? const Color(0xFFDB5B2B)
                        : Colors.grey[200]!),
              ),
              alignment: Alignment.center,
              child: Text(
                category.toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCoursesList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      itemCount: _filteredCourses.length,
      itemBuilder: (context, index) {
        final course = _filteredCourses[index];
        return CourseCard(
          course: course,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailScreen(course: course),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Курстар табылмады',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Басқа сұранысты іздеп көріңіз',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const CourseCard({
    Key? key,
    required this.course,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  course.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[100],
                      child: Center(
                        child: Icon(Icons.image,
                            color: Colors.grey[400], size: 32),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDB5B2B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          course.category,
                          style: const TextStyle(
                            color: Color(0xFFDB5B2B),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${course.lessons.length} сабақ',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                course.title,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    course.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[100],
                        child: Center(
                          child: Icon(Icons.image,
                              color: Colors.grey[400], size: 32),
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          course.category,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          Icon(Icons.book, size: 16, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            '${course.lessons.length} сабақ',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Курс жайлы',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    course.description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Сабақтар',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final lesson = course.lessons[index];
                return LessonCard(
                  lesson: lesson,
                  index: index,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LessonDetailScreen(
                          courseTitle: course.title,
                          lesson: lesson,
                        ),
                      ),
                    );
                  },
                );
              },
              childCount: course.lessons.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }
}

class LessonCard extends StatelessWidget {
  final CourseLesson lesson;
  final int index;
  final VoidCallback onTap;

  const LessonCard({
    Key? key,
    required this.lesson,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDB5B2B).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Color(0xFFDB5B2B),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    lesson.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LessonDetailScreen extends StatelessWidget {
  final String courseTitle;
  final CourseLesson lesson;

  const LessonDetailScreen({
    Key? key,
    required this.courseTitle,
    required this.lesson,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(courseTitle),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lesson.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            if (lesson.images.isNotEmpty) _buildImageCarousel(context),
            const SizedBox(height: 24),
            Text(
              lesson.content,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel(BuildContext context) {
    return Column(
      children: [
        if (lesson.images.length == 1)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              lesson.images.first,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[100],
                  child: Center(
                    child: Icon(Icons.image, color: Colors.grey[400], size: 32),
                  ),
                );
              },
            ),
          )
        else
          SizedBox(
            height: 200,
            child: PageView.builder(
              itemCount: lesson.images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      lesson.images[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[100],
                          child: Center(
                            child: Icon(Icons.image,
                                color: Colors.grey[400], size: 32),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
