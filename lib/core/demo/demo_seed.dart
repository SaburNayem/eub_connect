import 'package:eub_connect/core/demo/demo_models.dart';
import 'package:eub_connect/feature/home/model/static_feature.dart';

class DemoSeed {
  const DemoSeed._();

  static JsonMap snapshot() {
    final offices = _offices();
    final departments = _departments();
    final programs = _programs();
    final accounts = _accounts();
    final courses = _courses();
    final sections = _sections();
    final academicSemesters = _academicSemesters();
    final calendarEvents = _calendarEvents();
    final enrollments = _enrollments();
    final schedules = _schedules();
    final attendance = _attendance(enrollments);
    final assignments = _assignments();
    final submissions = _submissions();
    final quizzes = _quizzes();
    final attempts = _quizAttempts();
    final examSchedules = _examSchedules(sections);
    final studentRequests = _studentRequests();
    final admissions = _admissions();
    final notices = _notices();
    final events = _events();
    final eventRegistrations = _eventRegistrations();
    final clubs = _clubs();
    final clubMemberships = _clubMemberships();
    final lostFoundItems = _lostFoundItems();
    final forumCategories = _forumCategories();
    final forumPosts = _forumPosts();
    final forumComments = _forumComments(forumPosts);
    final forumReports = _forumReports(forumPosts);
    final tickets = _supportTickets();
    final messages = _supportMessages();
    final invoices = _invoices();
    final payments = _payments(invoices);
    final results = _results();
    final scholarships = _scholarships();
    final notifications = _notifications();
    final approvals = _approvals();
    final activities = _activities();

    return {
      'accounts': accounts.map((item) => item.toJson()).toList(),
      'offices': offices.map((item) => item.toJson()).toList(),
      'departments': departments.map((item) => item.toJson()).toList(),
      'programs': programs.map((item) => item.toJson()).toList(),
      'courses': courses.map((item) => item.toJson()).toList(),
      'sections': sections.map((item) => item.toJson()).toList(),
      'academicSemesters': academicSemesters
          .map((item) => item.toJson())
          .toList(),
      'calendarEvents': calendarEvents.map((item) => item.toJson()).toList(),
      'enrollments': enrollments.map((item) => item.toJson()).toList(),
      'schedules': schedules.map((item) => item.toJson()).toList(),
      'attendance': attendance.map((item) => item.toJson()).toList(),
      'assignments': assignments.map((item) => item.toJson()).toList(),
      'submissions': submissions.map((item) => item.toJson()).toList(),
      'quizzes': quizzes.map((item) => item.toJson()).toList(),
      'quizAttempts': attempts.map((item) => item.toJson()).toList(),
      'examSchedules': examSchedules.map((item) => item.toJson()).toList(),
      'studentRequests': studentRequests.map((item) => item.toJson()).toList(),
      'admissions': admissions.map((item) => item.toJson()).toList(),
      'notices': notices.map((item) => item.toJson()).toList(),
      'events': events.map((item) => item.toJson()).toList(),
      'eventRegistrations': eventRegistrations
          .map((item) => item.toJson())
          .toList(),
      'clubs': clubs.map((item) => item.toJson()).toList(),
      'clubMemberships': clubMemberships.map((item) => item.toJson()).toList(),
      'lostFoundItems': lostFoundItems.map((item) => item.toJson()).toList(),
      'forumCategories': forumCategories.map((item) => item.toJson()).toList(),
      'forumPosts': forumPosts.map((item) => item.toJson()).toList(),
      'forumComments': forumComments.map((item) => item.toJson()).toList(),
      'forumReports': forumReports.map((item) => item.toJson()).toList(),
      'supportTickets': tickets.map((item) => item.toJson()).toList(),
      'supportMessages': messages.map((item) => item.toJson()).toList(),
      'invoices': invoices.map((item) => item.toJson()).toList(),
      'payments': payments.map((item) => item.toJson()).toList(),
      'results': results.map((item) => item.toJson()).toList(),
      'scholarships': scholarships.map((item) => item.toJson()).toList(),
      'notifications': notifications.map((item) => item.toJson()).toList(),
      'approvals': approvals.map((item) => item.toJson()).toList(),
      'activities': activities.map((item) => item.toJson()).toList(),
      'currentAccountId': null,
    };
  }

  static List<DemoOffice> _offices() {
    return const [
      DemoOffice(
        id: 'office-registrar',
        name: 'Office of the Registrar',
        shortName: 'Registrar',
        headId: 'u-admstaff-001',
        status: 'Operational',
        responsibilities: [
          'Student records',
          'Registration verification',
          'Academic documents',
          'Certificate coordination',
        ],
      ),
      DemoOffice(
        id: 'office-accounts',
        name: 'Office of the Treasurer / Accounts',
        shortName: 'Accounts',
        headId: 'u-admstaff-002',
        status: 'Operational',
        responsibilities: [
          'Student ledger',
          'Payment verification',
          'Waiver cases',
          'Financial clearance',
        ],
      ),
      DemoOffice(
        id: 'office-exams',
        name: 'Office of the Controller of Examinations',
        shortName: 'Examinations',
        headId: 'u-admstaff-003',
        status: 'Operational',
        responsibilities: [
          'Exam schedules',
          'Admit cards',
          'Result review',
          'Transcript and certificate requests',
        ],
      ),
      DemoOffice(
        id: 'office-admission',
        name: 'Admission & Student Affairs',
        shortName: 'Admissions',
        headId: 'u-admstaff-004',
        status: 'Operational',
        responsibilities: [
          'Admission applications',
          'Student service desk',
          'Events and clubs',
          'Registration progress',
        ],
      ),
      DemoOffice(
        id: 'office-planning',
        name: 'Planning & Development',
        shortName: 'P&D',
        headId: 'u-admstaff-005',
        status: 'Monitoring',
        responsibilities: [
          'Campus planning',
          'Policy follow-up',
          'Development tasks',
        ],
      ),
      DemoOffice(
        id: 'office-program',
        name: 'Program Coordination Department',
        shortName: 'Program Coordination',
        headId: 'u-admstaff-006',
        status: 'Operational',
        responsibilities: [
          'Program records',
          'Section coordination',
          'Department follow-up',
        ],
      ),
      DemoOffice(
        id: 'office-library',
        name: 'Library & Module Archive',
        shortName: 'Library',
        headId: 'u-admstaff-007',
        status: 'Operational',
        responsibilities: [
          'Module archive',
          'Library service cases',
          'Clearance support',
        ],
      ),
      DemoOffice(
        id: 'office-procurement',
        name: 'Procurement & Inventory',
        shortName: 'Inventory',
        headId: 'u-admstaff-008',
        status: 'Operational',
        responsibilities: [
          'Procurement requests',
          'Inventory status',
          'Equipment issues',
        ],
      ),
      DemoOffice(
        id: 'office-iqac',
        name: 'Office of the IQAC',
        shortName: 'IQAC',
        headId: 'u-admstaff-009',
        status: 'Review Cycle',
        responsibilities: [
          'Quality review',
          'Course evaluation',
          'Department performance reports',
        ],
      ),
      DemoOffice(
        id: 'office-ict',
        name: 'ICT & Laboratory',
        shortName: 'ICT',
        headId: 'u-admstaff-010',
        status: 'Operational',
        responsibilities: [
          'Portal support',
          'Laboratory status',
          'Equipment tickets',
        ],
      ),
      DemoOffice(
        id: 'office-proctor',
        name: 'Office of the Proctor',
        shortName: 'Proctor',
        headId: 'u-admstaff-011',
        status: 'Operational',
        responsibilities: [
          'Complaints',
          'Discipline cases',
          'Incident reports',
        ],
      ),
      DemoOffice(
        id: 'office-ccc',
        name: 'Office of the CCC',
        shortName: 'CCC',
        headId: 'u-admstaff-012',
        status: 'Operational',
        responsibilities: [
          'Career services',
          'Club coordination',
          'Skill events',
        ],
      ),
    ];
  }

  static List<DemoDepartment> _departments() {
    return const [
      DemoDepartment(
        id: 'dept-cse',
        name: 'Computer Science & Engineering',
        shortName: 'CSE',
        faculty: 'Faculty of Science and Engineering',
      ),
      DemoDepartment(
        id: 'dept-eee',
        name: 'Electrical & Electronic Engineering',
        shortName: 'EEE',
        faculty: 'Faculty of Science and Engineering',
      ),
      DemoDepartment(
        id: 'dept-bba',
        name: 'Business Administration',
        shortName: 'BBA',
        faculty: 'Faculty of Business Studies',
      ),
      DemoDepartment(
        id: 'dept-eng',
        name: 'English',
        shortName: 'ENG',
        faculty: 'Faculty of Arts and Social Sciences',
      ),
      DemoDepartment(
        id: 'dept-ce',
        name: 'Civil Engineering',
        shortName: 'CE',
        faculty: 'Faculty of Science and Engineering',
      ),
      DemoDepartment(
        id: 'dept-ipe',
        name: 'Industrial and Production Engineering',
        shortName: 'IPE',
        faculty: 'Faculty of Science and Engineering',
      ),
      DemoDepartment(
        id: 'dept-textile',
        name: 'Textile Engineering',
        shortName: 'TE',
        faculty: 'Faculty of Science and Engineering',
      ),
      DemoDepartment(
        id: 'dept-law',
        name: 'Law',
        shortName: 'LAW',
        faculty: 'Faculty of Arts and Social Sciences',
      ),
      DemoDepartment(
        id: 'dept-economics',
        name: 'Economics',
        shortName: 'ECO',
        faculty: 'Faculty of Arts and Social Sciences',
      ),
    ];
  }

  static List<DemoProgram> _programs() {
    return const [
      DemoProgram(
        id: 'program-cse-bsc',
        departmentId: 'dept-cse',
        code: 'BSC-CSE',
        title: 'B.Sc. in Computer Science and Engineering',
        degreeType: 'Undergraduate',
        totalCredits: 160,
        duration: '4 years',
      ),
      DemoProgram(
        id: 'program-eee-bsc',
        departmentId: 'dept-eee',
        code: 'BSC-EEE',
        title: 'B.Sc. in Electrical and Electronic Engineering',
        degreeType: 'Undergraduate',
        totalCredits: 160,
        duration: '4 years',
      ),
      DemoProgram(
        id: 'program-ce-bsc',
        departmentId: 'dept-ce',
        code: 'BSC-CE',
        title: 'B.Sc. in Civil Engineering',
        degreeType: 'Undergraduate',
        totalCredits: 165,
        duration: '4 years',
      ),
      DemoProgram(
        id: 'program-ipe-bsc',
        departmentId: 'dept-ipe',
        code: 'BSC-IPE',
        title: 'B.Sc. in Industrial and Production Engineering',
        degreeType: 'Undergraduate',
        totalCredits: 160,
        duration: '4 years',
      ),
      DemoProgram(
        id: 'program-bba',
        departmentId: 'dept-bba',
        code: 'BBA',
        title: 'Bachelor of Business Administration',
        degreeType: 'Undergraduate',
        totalCredits: 126,
        duration: '4 years',
      ),
      DemoProgram(
        id: 'program-mba',
        departmentId: 'dept-bba',
        code: 'MBA',
        title: 'Master of Business Administration',
        degreeType: 'Graduate',
        totalCredits: 60,
        duration: '2 years',
      ),
      DemoProgram(
        id: 'program-eng-ba',
        departmentId: 'dept-eng',
        code: 'BA-ENG',
        title: 'B.A. in English',
        degreeType: 'Undergraduate',
        totalCredits: 120,
        duration: '4 years',
      ),
      DemoProgram(
        id: 'program-law-llb',
        departmentId: 'dept-law',
        code: 'LLB',
        title: 'Bachelor of Laws',
        degreeType: 'Undergraduate',
        totalCredits: 135,
        duration: '4 years',
      ),
      DemoProgram(
        id: 'program-eco-bss',
        departmentId: 'dept-economics',
        code: 'BSS-ECO',
        title: 'BSS in Economics',
        degreeType: 'Undergraduate',
        totalCredits: 126,
        duration: '4 years',
      ),
    ];
  }

  static List<DemoAcademicSemester> _academicSemesters() {
    return [
      DemoAcademicSemester(
        id: 'sem-fall-2025',
        name: 'Fall 2025',
        registrationStart: DateTime(2025, 9, 1),
        registrationEnd: DateTime(2025, 9, 12),
        classStart: DateTime(2025, 9, 15),
        midtermStart: DateTime(2025, 11, 1),
        midtermEnd: DateTime(2025, 11, 12),
        finalStart: DateTime(2026, 1, 3),
        finalEnd: DateTime(2026, 1, 14),
        resultPublication: DateTime(2026, 1, 30),
        status: 'Completed',
      ),
      DemoAcademicSemester(
        id: 'sem-spring-2026',
        name: 'Spring 2026',
        registrationStart: DateTime(2026, 1, 5),
        registrationEnd: DateTime(2026, 1, 16),
        classStart: DateTime(2026, 1, 18),
        midtermStart: DateTime(2026, 3, 10),
        midtermEnd: DateTime(2026, 3, 21),
        finalStart: DateTime(2026, 7, 29),
        finalEnd: DateTime(2026, 8, 12),
        resultPublication: DateTime(2026, 8, 30),
        status: 'Current',
      ),
      DemoAcademicSemester(
        id: 'sem-summer-2026',
        name: 'Summer 2026',
        registrationStart: DateTime(2026, 8, 20),
        registrationEnd: DateTime(2026, 9, 3),
        classStart: DateTime(2026, 9, 6),
        midtermStart: DateTime(2026, 10, 17),
        midtermEnd: DateTime(2026, 10, 27),
        finalStart: DateTime(2026, 12, 12),
        finalEnd: DateTime(2026, 12, 24),
        resultPublication: DateTime(2027, 1, 15),
        status: 'Upcoming',
      ),
    ];
  }

  static List<DemoCalendarEvent> _calendarEvents() {
    return [
      DemoCalendarEvent(
        id: 'cal-001',
        semesterId: 'sem-spring-2026',
        title: 'Spring 2026 registration',
        type: 'Registration',
        startDate: DateTime(2026, 1, 5),
        endDate: DateTime(2026, 1, 16),
        audience: 'Students',
        status: 'Completed',
      ),
      DemoCalendarEvent(
        id: 'cal-002',
        semesterId: 'sem-spring-2026',
        title: 'Regular classes begin',
        type: 'Class',
        startDate: DateTime(2026, 1, 18),
        endDate: DateTime(2026, 1, 18),
        audience: 'All',
        status: 'Completed',
      ),
      DemoCalendarEvent(
        id: 'cal-003',
        semesterId: 'sem-spring-2026',
        title: 'Midterm examination period',
        type: 'Exam',
        startDate: DateTime(2026, 3, 10),
        endDate: DateTime(2026, 3, 21),
        audience: 'Students',
        status: 'Completed',
      ),
      DemoCalendarEvent(
        id: 'cal-004',
        semesterId: 'sem-spring-2026',
        title: 'Final exam form fill-up and clearance',
        type: 'Finance',
        startDate: DateTime(2026, 7, 20),
        endDate: DateTime(2026, 7, 28),
        audience: 'Students',
        status: 'Active',
      ),
      DemoCalendarEvent(
        id: 'cal-005',
        semesterId: 'sem-spring-2026',
        title: 'Final examination period',
        type: 'Exam',
        startDate: DateTime(2026, 7, 29),
        endDate: DateTime(2026, 8, 12),
        audience: 'All',
        status: 'Upcoming',
      ),
      DemoCalendarEvent(
        id: 'cal-006',
        semesterId: 'sem-spring-2026',
        title: 'Result publication target',
        type: 'Result',
        startDate: DateTime(2026, 8, 30),
        endDate: DateTime(2026, 8, 30),
        audience: 'Students',
        status: 'Scheduled',
      ),
    ];
  }

  static List<DemoAccount> _accounts() {
    final students =
        [
          ['u-stu-001', '2023001001', 'student@eub.edu.bd', 'Nayem Ahmed'],
          [
            'u-stu-002',
            '2023001002',
            'sabbir.hossain@eub.edu.bd',
            'Sabbir Hossain',
          ],
          [
            'u-stu-003',
            '2023001003',
            'mehedi.hasan@eub.edu.bd',
            'Mehedi Hasan',
          ],
          [
            'u-stu-004',
            '2023001004',
            'tasnim.akter@eub.edu.bd',
            'Tasnim Akter',
          ],
          ['u-stu-005', '2023001005', 'rafi.islam@eub.edu.bd', 'Rafi Islam'],
          [
            'u-stu-006',
            '2023001006',
            'nusrat.jahan.stu@eub.edu.bd',
            'Nusrat Jahan',
          ],
          ['u-stu-007', '2023001007', 'arif.rahman@eub.edu.bd', 'Arif Rahman'],
          [
            'u-stu-008',
            '2023001008',
            'maliha.karim@eub.edu.bd',
            'Maliha Karim',
          ],
          ['u-stu-009', '2023001009', 'shakib.alam@eub.edu.bd', 'Shakib Alam'],
          [
            'u-stu-010',
            '2023001010',
            'farzana.hoque@eub.edu.bd',
            'Farzana Hoque',
          ],
          [
            'u-stu-011',
            '2023001011',
            'tanvir.hasan@eub.edu.bd',
            'Tanvir Hasan',
          ],
          [
            'u-stu-012',
            '2023001012',
            'lamia.sultana@eub.edu.bd',
            'Lamia Sultana',
          ],
          [
            'u-stu-013',
            '2023001013',
            'rakibul.islam@eub.edu.bd',
            'Rakibul Islam',
          ],
          ['u-stu-014', '2023001014', 'afrin.jahan@eub.edu.bd', 'Afrin Jahan'],
          ['u-stu-015', '2023001015', 'saif.mahmud@eub.edu.bd', 'Saif Mahmud'],
          [
            'u-stu-016',
            '2023001016',
            'sumaiya.akter@eub.edu.bd',
            'Sumaiya Akter',
          ],
          [
            'u-stu-017',
            '2023001017',
            'fahim.rahman@eub.edu.bd',
            'Fahim Rahman',
          ],
          [
            'u-stu-018',
            '2023001018',
            'jannatul.ferdous@eub.edu.bd',
            'Jannatul Ferdous',
          ],
          ['u-stu-019', '2023001019', 'abrar.haque@eub.edu.bd', 'Abrar Haque'],
          ['u-stu-020', '2023001020', 'sadia.naz@eub.edu.bd', 'Sadia Naz'],
        ].map((student) {
          final index = int.parse(student[1].substring(student[1].length - 2));
          final semester = index <= 10 ? 'Spring 2026' : 'Summer 2026';
          final section = index <= 12 ? '6A' : '5B';
          return DemoAccount(
            id: student[0],
            universityId: student[1],
            email: student[2],
            password: '123456',
            fullName: student[3],
            role: PortalRole.student,
            departmentId: index <= 16 ? 'dept-cse' : 'dept-eee',
            program: index <= 16 ? 'B.Sc. in CSE' : 'B.Sc. in EEE',
            semester: semester,
            section: section,
            batch: '23',
            phone: '+88017${(10000000 + index * 4317).toString().substring(1)}',
            address:
                'House ${12 + index}, Road ${3 + index % 8}, Mirpur, Dhaka',
            emergencyContact:
                '+88018${(10000000 + index * 5721).toString().substring(1)}',
            cgpa: 3.10 + (index % 7) * 0.11,
            completedCredits: 82 + index,
            currentCredits: 15,
          );
        }).toList();
    final generatedStudents = List.generate(160, (offset) {
      final index = offset + 21;
      final id = index.toString().padLeft(3, '0');
      final firstNames = [
        'Afsana',
        'Mahin',
        'Tanjim',
        'Samiha',
        'Imran',
        'Nabila',
        'Raihan',
        'Faria',
        'Shuvo',
        'Muntaha',
        'Rumana',
        'Sakib',
        'Ishrat',
        'Sohan',
        'Nadim',
        'Mim',
      ];
      final lastNames = [
        'Ahmed',
        'Rahman',
        'Islam',
        'Hossain',
        'Akter',
        'Hasan',
        'Karim',
        'Chowdhury',
        'Sultana',
        'Mahmud',
      ];
      final name =
          '${firstNames[offset % firstNames.length]} ${lastNames[(offset ~/ firstNames.length) % lastNames.length]}';
      final departmentIds = [
        'dept-cse',
        'dept-cse',
        'dept-eee',
        'dept-bba',
        'dept-eng',
        'dept-ce',
      ];
      final departmentId = departmentIds[offset % departmentIds.length];
      final program = switch (departmentId) {
        'dept-eee' => 'B.Sc. in EEE',
        'dept-bba' => 'BBA',
        'dept-eng' => 'B.A. in English',
        'dept-ce' => 'B.Sc. in Civil Engineering',
        _ => 'B.Sc. in CSE',
      };
      return DemoAccount(
        id: 'u-stu-$id',
        universityId: '2023001$id',
        email: '${name.toLowerCase().replaceAll(' ', '.')}.$id@eub.edu.bd',
        password: '123456',
        fullName: name,
        role: PortalRole.student,
        departmentId: departmentId,
        program: program,
        semester: offset % 3 == 0
            ? 'Spring 2026'
            : offset % 3 == 1
            ? 'Summer 2026'
            : 'Fall 2025',
        section: offset.isEven ? '6A' : '5B',
        batch: '${22 + (offset % 4)}',
        phone: '+88017${(20000000 + index * 1973).toString().substring(1)}',
        address:
            'House ${20 + index % 90}, Road ${1 + index % 18}, ${index.isEven ? 'Uttara' : 'Mirpur'}, Dhaka',
        emergencyContact:
            '+88018${(30000000 + index * 2141).toString().substring(1)}',
        cgpa: 2.75 + (index % 11) * 0.10,
        completedCredits: 42 + (index % 80),
        currentCredits: 12 + (index % 3) * 3,
      );
    });

    return [
      ...students,
      ...generatedStudents,
      DemoAccount(
        id: 'u-tea-001',
        universityId: 'T1001',
        email: 'teacher@eub.edu.bd',
        password: '123456',
        fullName: 'Dr. Farhan Rahman',
        role: PortalRole.teacher,
        departmentId: 'dept-cse',
        designation: 'Associate Professor',
        phone: '+8801711201001',
      ),
      DemoAccount(
        id: 'u-tea-002',
        universityId: 'T1002',
        email: 'nusrat.teacher@eub.edu.bd',
        password: '123456',
        fullName: 'Lecturer Nusrat Jahan',
        role: PortalRole.teacher,
        departmentId: 'dept-cse',
        designation: 'Lecturer',
        phone: '+8801711201002',
      ),
      DemoAccount(
        id: 'u-tea-003',
        universityId: 'T1003',
        email: 'tanvir.ahmed@eub.edu.bd',
        password: '123456',
        fullName: 'Md. Tanvir Ahmed',
        role: PortalRole.teacher,
        departmentId: 'dept-eee',
        designation: 'Assistant Professor',
      ),
      DemoAccount(
        id: 'u-tea-004',
        universityId: 'T1004',
        email: 'sadia.islam@eub.edu.bd',
        password: '123456',
        fullName: 'Dr. Sadia Islam',
        role: PortalRole.teacher,
        departmentId: 'dept-bba',
        designation: 'Professor',
      ),
      DemoAccount(
        id: 'u-tea-005',
        universityId: 'T1005',
        email: 'mahmudul.karim@eub.edu.bd',
        password: '123456',
        fullName: 'Mahmudul Karim',
        role: PortalRole.teacher,
        departmentId: 'dept-cse',
        designation: 'Senior Lecturer',
      ),
      DemoAccount(
        id: 'u-tea-006',
        universityId: 'T1006',
        email: 'sharmin.sultana@eub.edu.bd',
        password: '123456',
        fullName: 'Sharmin Sultana',
        role: PortalRole.teacher,
        departmentId: 'dept-eng',
        designation: 'Lecturer',
      ),
      DemoAccount(
        id: 'u-tea-007',
        universityId: 'T1007',
        email: 'rezwan.haque@eub.edu.bd',
        password: '123456',
        fullName: 'Rezwan Haque',
        role: PortalRole.teacher,
        departmentId: 'dept-ce',
        designation: 'Assistant Professor',
      ),
      DemoAccount(
        id: 'u-tea-008',
        universityId: 'T1008',
        email: 'amina.begum@eub.edu.bd',
        password: '123456',
        fullName: 'Amina Begum',
        role: PortalRole.teacher,
        departmentId: 'dept-cse',
        designation: 'Lecturer',
      ),
      DemoAccount(
        id: 'u-tea-009',
        universityId: 'T1009',
        email: 'hasan.mahmud@eub.edu.bd',
        password: '123456',
        fullName: 'Hasan Mahmud',
        role: PortalRole.teacher,
        departmentId: 'dept-bba',
        designation: 'Lecturer',
      ),
      DemoAccount(
        id: 'u-tea-010',
        universityId: 'T1010',
        email: 'umme.salima@eub.edu.bd',
        password: '123456',
        fullName: 'Umme Salima',
        role: PortalRole.teacher,
        departmentId: 'dept-eee',
        designation: 'Lecturer',
      ),
      ..._administrationStaff(),
      DemoAccount(
        id: 'u-adm-001',
        universityId: 'ADMIN001',
        email: 'admin@eub.edu.bd',
        password: '123456',
        fullName: 'System Administrator',
        role: PortalRole.admin,
        departmentId: 'dept-cse',
        designation: 'Admin Officer',
        phone: '+8801711401001',
      ),
    ];
  }

  static List<DemoAccount> _administrationStaff() {
    final rows = [
      (
        'u-admstaff-001',
        'EUB-REG-1001',
        'administration@eub.edu.bd',
        'Md. Rakib Hasan',
        'office-registrar',
        'Assistant Registrar',
        'dept-cse',
        ['Registration verification', 'Student records', 'Certificate desk'],
      ),
      (
        'u-admstaff-002',
        'EUB-ACC-1002',
        'accounts.office@eub.edu.bd',
        'Farzana Rahman',
        'office-accounts',
        'Accounts Officer',
        'dept-bba',
        ['Ledger review', 'Payment verification', 'Waiver cases'],
      ),
      (
        'u-admstaff-003',
        'EUB-EXM-1003',
        'exam.office@eub.edu.bd',
        'Hafizur Rahman',
        'office-exams',
        'Examination Officer',
        'dept-cse',
        ['Exam schedule', 'Result review', 'Transcript requests'],
      ),
      (
        'u-admstaff-004',
        'EUB-ASA-1004',
        'admission.office@eub.edu.bd',
        'Nusrat Akter',
        'office-admission',
        'Admission Officer',
        'dept-bba',
        ['Application review', 'Student affairs', 'Event coordination'],
      ),
      (
        'u-admstaff-005',
        'EUB-PND-1005',
        'planning.office@eub.edu.bd',
        'Sabbir Ahmed',
        'office-planning',
        'Planning Officer',
        'dept-ce',
        ['Development task follow-up', 'Policy tracking', 'Reporting'],
      ),
      (
        'u-admstaff-006',
        'EUB-PCD-1006',
        'program.office@eub.edu.bd',
        'Mahbub Karim',
        'office-program',
        'Program Coordination Officer',
        'dept-cse',
        ['Program records', 'Section coordination', 'Course catalog review'],
      ),
      (
        'u-admstaff-007',
        'EUB-LIB-1007',
        'library.office@eub.edu.bd',
        'Samia Sultana',
        'office-library',
        'Library Officer',
        'dept-eng',
        ['Module archive', 'Library clearance', 'Resource requests'],
      ),
      (
        'u-admstaff-008',
        'EUB-INV-1008',
        'inventory.office@eub.edu.bd',
        'Tanvir Mahmud',
        'office-procurement',
        'Procurement Officer',
        'dept-eee',
        ['Inventory review', 'Equipment issue tracking', 'Purchase files'],
      ),
      (
        'u-admstaff-009',
        'EUB-IQAC-1009',
        'iqac.office@eub.edu.bd',
        'Dr. Maliha Karim',
        'office-iqac',
        'Quality Assurance Officer',
        'dept-cse',
        ['Course evaluation', 'Quality reports', 'Department performance'],
      ),
      (
        'u-admstaff-010',
        'EUB-ICT-1010',
        'ict.office@eub.edu.bd',
        'Raihan Islam',
        'office-ict',
        'ICT Support Officer',
        'dept-cse',
        ['Portal tickets', 'Laboratory status', 'Equipment support'],
      ),
      (
        'u-admstaff-011',
        'EUB-PRO-1011',
        'proctor.office@eub.edu.bd',
        'Adv. Sadia Hoque',
        'office-proctor',
        'Assistant Proctor',
        'dept-law',
        ['Complaints', 'Discipline cases', 'Incident follow-up'],
      ),
      (
        'u-admstaff-012',
        'EUB-CCC-1012',
        'ccc.office@eub.edu.bd',
        'Arman Hossain',
        'office-ccc',
        'Career Services Officer',
        'dept-bba',
        ['Career events', 'Club coordination', 'Employer communication'],
      ),
    ];

    return rows.map((row) {
      return DemoAccount(
        id: row.$1,
        universityId: row.$2,
        email: row.$3,
        password: '123456',
        fullName: row.$4,
        role: PortalRole.administration,
        departmentId: row.$7,
        officeId: row.$5,
        designation: row.$6,
        phone: '+88017113${row.$2.substring(row.$2.length - 4)}',
        responsibilities: row.$8,
      );
    }).toList();
  }

  static List<DemoCourse> _courses() {
    return const [
      DemoCourse(
        id: 'course-cse231',
        departmentId: 'dept-cse',
        code: 'CSE 231',
        title: 'Data Structures',
        credits: 3,
      ),
      DemoCourse(
        id: 'course-cse315',
        departmentId: 'dept-cse',
        code: 'CSE 315',
        title: 'Database Management Systems',
        credits: 3,
      ),
      DemoCourse(
        id: 'course-cse331',
        departmentId: 'dept-cse',
        code: 'CSE 331',
        title: 'Software Engineering',
        credits: 3,
      ),
      DemoCourse(
        id: 'course-cse341',
        departmentId: 'dept-cse',
        code: 'CSE 341',
        title: 'Operating Systems',
        credits: 3,
      ),
      DemoCourse(
        id: 'course-cse410',
        departmentId: 'dept-cse',
        code: 'CSE 410',
        title: 'Artificial Intelligence',
        credits: 3,
      ),
      DemoCourse(
        id: 'course-cse420',
        departmentId: 'dept-cse',
        code: 'CSE 420',
        title: 'Computer Networks',
        credits: 3,
      ),
      DemoCourse(
        id: 'course-cse425',
        departmentId: 'dept-cse',
        code: 'CSE 425',
        title: 'Web Engineering',
        credits: 3,
      ),
      DemoCourse(
        id: 'course-eee201',
        departmentId: 'dept-eee',
        code: 'EEE 201',
        title: 'Electrical Circuits',
        credits: 3,
      ),
      DemoCourse(
        id: 'course-eee305',
        departmentId: 'dept-eee',
        code: 'EEE 305',
        title: 'Digital Electronics',
        credits: 3,
      ),
      DemoCourse(
        id: 'course-bus201',
        departmentId: 'dept-bba',
        code: 'BUS 201',
        title: 'Principles of Management',
        credits: 3,
      ),
      DemoCourse(
        id: 'course-bus321',
        departmentId: 'dept-bba',
        code: 'BUS 321',
        title: 'Financial Accounting',
        credits: 3,
      ),
      DemoCourse(
        id: 'course-eng205',
        departmentId: 'dept-eng',
        code: 'ENG 205',
        title: 'Business Communication',
        credits: 3,
      ),
      DemoCourse(
        id: 'course-ce211',
        departmentId: 'dept-ce',
        code: 'CE 211',
        title: 'Engineering Mechanics',
        credits: 3,
      ),
      DemoCourse(
        id: 'course-mat205',
        departmentId: 'dept-cse',
        code: 'MAT 205',
        title: 'Numerical Methods',
        credits: 3,
      ),
      DemoCourse(
        id: 'course-sta301',
        departmentId: 'dept-bba',
        code: 'STA 301',
        title: 'Business Statistics',
        credits: 3,
      ),
    ];
  }

  static List<DemoSection> _sections() {
    return const [
      DemoSection(
        id: 'sec-cse231-6a',
        courseId: 'course-cse231',
        teacherId: 'u-tea-002',
        sectionCode: '6A',
        semester: 'Spring 2026',
        capacity: 45,
      ),
      DemoSection(
        id: 'sec-cse315-6a',
        courseId: 'course-cse315',
        teacherId: 'u-tea-001',
        sectionCode: '6A',
        semester: 'Spring 2026',
        capacity: 45,
      ),
      DemoSection(
        id: 'sec-cse331-6a',
        courseId: 'course-cse331',
        teacherId: 'u-tea-001',
        sectionCode: '6A',
        semester: 'Spring 2026',
        capacity: 42,
      ),
      DemoSection(
        id: 'sec-cse341-6a',
        courseId: 'course-cse341',
        teacherId: 'u-tea-005',
        sectionCode: '6A',
        semester: 'Spring 2026',
        capacity: 42,
      ),
      DemoSection(
        id: 'sec-mat205-6a',
        courseId: 'course-mat205',
        teacherId: 'u-tea-008',
        sectionCode: '6A',
        semester: 'Spring 2026',
        capacity: 45,
      ),
      DemoSection(
        id: 'sec-eee201-6a',
        courseId: 'course-eee201',
        teacherId: 'u-tea-003',
        sectionCode: '6A',
        semester: 'Spring 2026',
        capacity: 40,
      ),
      DemoSection(
        id: 'sec-cse410-5b',
        courseId: 'course-cse410',
        teacherId: 'u-tea-002',
        sectionCode: '5B',
        semester: 'Summer 2026',
        capacity: 36,
      ),
      DemoSection(
        id: 'sec-cse420-5b',
        courseId: 'course-cse420',
        teacherId: 'u-tea-005',
        sectionCode: '5B',
        semester: 'Summer 2026',
        capacity: 36,
      ),
      DemoSection(
        id: 'sec-cse425-5b',
        courseId: 'course-cse425',
        teacherId: 'u-tea-008',
        sectionCode: '5B',
        semester: 'Summer 2026',
        capacity: 34,
      ),
      DemoSection(
        id: 'sec-eee305-5b',
        courseId: 'course-eee305',
        teacherId: 'u-tea-010',
        sectionCode: '5B',
        semester: 'Summer 2026',
        capacity: 36,
      ),
      DemoSection(
        id: 'sec-bus201-1a',
        courseId: 'course-bus201',
        teacherId: 'u-tea-004',
        sectionCode: '1A',
        semester: 'Spring 2026',
        capacity: 50,
      ),
      DemoSection(
        id: 'sec-bus321-3a',
        courseId: 'course-bus321',
        teacherId: 'u-tea-009',
        sectionCode: '3A',
        semester: 'Spring 2026',
        capacity: 45,
      ),
      DemoSection(
        id: 'sec-eng205-6a',
        courseId: 'course-eng205',
        teacherId: 'u-tea-006',
        sectionCode: '6A',
        semester: 'Spring 2026',
        capacity: 45,
      ),
      DemoSection(
        id: 'sec-ce211-2a',
        courseId: 'course-ce211',
        teacherId: 'u-tea-007',
        sectionCode: '2A',
        semester: 'Spring 2026',
        capacity: 38,
      ),
      DemoSection(
        id: 'sec-sta301-3a',
        courseId: 'course-sta301',
        teacherId: 'u-tea-009',
        sectionCode: '3A',
        semester: 'Spring 2026',
        capacity: 45,
      ),
    ];
  }

  static List<DemoEnrollment> _enrollments() {
    final enrollments = <DemoEnrollment>[];
    final springCse = [
      'sec-cse315-6a',
      'sec-cse331-6a',
      'sec-cse341-6a',
      'sec-mat205-6a',
      'sec-eng205-6a',
    ];
    final mixedCse = [
      'sec-cse231-6a',
      'sec-cse410-5b',
      'sec-cse420-5b',
      'sec-cse425-5b',
      'sec-mat205-6a',
    ];
    final eee = ['sec-eee201-6a', 'sec-eee305-5b', 'sec-mat205-6a'];
    final bba = ['sec-bus201-1a', 'sec-bus321-3a', 'sec-sta301-3a'];
    final english = ['sec-eng205-6a', 'sec-bus201-1a'];
    final civil = ['sec-ce211-2a', 'sec-mat205-6a'];

    for (var student = 1; student <= 180; student++) {
      final studentId = 'u-stu-${student.toString().padLeft(3, '0')}';
      final sectionIds = student <= 12
          ? springCse
          : student <= 16
          ? mixedCse
          : student <= 20
          ? eee
          : switch (student % 6) {
              0 => bba,
              1 => springCse,
              2 => mixedCse,
              3 => eee,
              4 => english,
              _ => civil,
            };
      for (final sectionId in sectionIds) {
        enrollments.add(
          DemoEnrollment(
            id: 'enr-$studentId-$sectionId',
            studentId: studentId,
            sectionId: sectionId,
            status: 'enrolled',
          ),
        );
      }
    }
    return enrollments;
  }

  static List<DemoScheduleEntry> _schedules() {
    return const [
      DemoScheduleEntry(
        id: 'sch-001',
        sectionId: 'sec-cse315-6a',
        day: 'Monday',
        start: '09:00 AM',
        end: '10:30 AM',
        room: 'CSE Lab 3',
        type: 'Lecture',
      ),
      DemoScheduleEntry(
        id: 'sch-002',
        sectionId: 'sec-cse331-6a',
        day: 'Monday',
        start: '11:00 AM',
        end: '12:30 PM',
        room: 'Room 502',
        type: 'Lecture',
      ),
      DemoScheduleEntry(
        id: 'sch-003',
        sectionId: 'sec-cse341-6a',
        day: 'Tuesday',
        start: '09:00 AM',
        end: '10:30 AM',
        room: 'Room 404',
        type: 'Lecture',
      ),
      DemoScheduleEntry(
        id: 'sch-004',
        sectionId: 'sec-mat205-6a',
        day: 'Tuesday',
        start: '02:00 PM',
        end: '03:30 PM',
        room: 'Room 302',
        type: 'Tutorial',
      ),
      DemoScheduleEntry(
        id: 'sch-005',
        sectionId: 'sec-eng205-6a',
        day: 'Wednesday',
        start: '09:00 AM',
        end: '10:30 AM',
        room: 'Room 203',
        type: 'Workshop',
      ),
      DemoScheduleEntry(
        id: 'sch-006',
        sectionId: 'sec-cse315-6a',
        day: 'Wednesday',
        start: '11:00 AM',
        end: '12:30 PM',
        room: 'CSE Lab 2',
        type: 'Lab',
      ),
      DemoScheduleEntry(
        id: 'sch-007',
        sectionId: 'sec-cse331-6a',
        day: 'Thursday',
        start: '09:00 AM',
        end: '10:30 AM',
        room: 'Room 502',
        type: 'Project Studio',
      ),
      DemoScheduleEntry(
        id: 'sch-008',
        sectionId: 'sec-cse341-6a',
        day: 'Saturday',
        start: '11:00 AM',
        end: '12:30 PM',
        room: 'Room 404',
        type: 'Lecture',
      ),
      DemoScheduleEntry(
        id: 'sch-009',
        sectionId: 'sec-cse231-6a',
        day: 'Sunday',
        start: '10:00 AM',
        end: '11:30 AM',
        room: 'CSE Lab 1',
        type: 'Lab',
      ),
      DemoScheduleEntry(
        id: 'sch-010',
        sectionId: 'sec-cse410-5b',
        day: 'Sunday',
        start: '02:00 PM',
        end: '03:30 PM',
        room: 'AI Lab',
        type: 'Lecture',
      ),
      DemoScheduleEntry(
        id: 'sch-011',
        sectionId: 'sec-cse420-5b',
        day: 'Tuesday',
        start: '11:00 AM',
        end: '12:30 PM',
        room: 'Network Lab',
        type: 'Lab',
      ),
      DemoScheduleEntry(
        id: 'sch-012',
        sectionId: 'sec-eee201-6a',
        day: 'Monday',
        start: '02:00 PM',
        end: '03:30 PM',
        room: 'EEE Lab 1',
        type: 'Circuit Lab',
      ),
      DemoScheduleEntry(
        id: 'sch-013',
        sectionId: 'sec-bus201-1a',
        day: 'Wednesday',
        start: '02:00 PM',
        end: '03:30 PM',
        room: 'Business 301',
        type: 'Lecture',
      ),
      DemoScheduleEntry(
        id: 'sch-014',
        sectionId: 'sec-ce211-2a',
        day: 'Thursday',
        start: '02:00 PM',
        end: '03:30 PM',
        room: 'Civil Studio',
        type: 'Drawing Lab',
      ),
    ];
  }

  static List<DemoAttendanceRecord> _attendance(
    List<DemoEnrollment> enrollments,
  ) {
    final dates = [
      DateTime(2026, 7, 6),
      DateTime(2026, 7, 8),
      DateTime(2026, 7, 13),
      DateTime(2026, 7, 15),
      DateTime(2026, 7, 20),
      DateTime(2026, 7, 22),
    ];
    final records = <DemoAttendanceRecord>[];
    for (final enrollment in enrollments) {
      for (var index = 0; index < dates.length; index++) {
        final hash =
            (enrollment.studentId.hashCode +
                    enrollment.sectionId.hashCode +
                    index)
                .abs();
        final status = hash % 13 == 0
            ? DemoAttendanceStatus.excused
            : hash % 7 == 0
            ? DemoAttendanceStatus.absent
            : hash % 5 == 0
            ? DemoAttendanceStatus.late
            : DemoAttendanceStatus.present;
        records.add(
          DemoAttendanceRecord(
            id: 'att-${enrollment.studentId}-${enrollment.sectionId}-$index',
            sectionId: enrollment.sectionId,
            studentId: enrollment.studentId,
            date: dates[index],
            slot: index.isEven ? '09:00 AM' : '11:00 AM',
            status: status,
            note: status == DemoAttendanceStatus.absent
                ? 'Class missed and visible in attendance history'
                : status == DemoAttendanceStatus.late
                ? 'Entered within the late attendance window'
                : status == DemoAttendanceStatus.excused
                ? 'Excused after approved application'
                : 'Attendance confirmed by course teacher',
          ),
        );
      }
    }
    return records;
  }

  static List<DemoAssignment> _assignments() {
    final items = [
      [
        'asg-001',
        'sec-cse315-6a',
        'u-tea-001',
        'Database Normalization Assignment',
        'Normalize the provided EUB course registration tables to 3NF and explain every dependency.',
        20,
        '2026-07-28',
        'DBMS-normalization-brief.pdf',
      ],
      [
        'asg-002',
        'sec-cse315-6a',
        'u-tea-001',
        'SQL Practice Sheet',
        'Write SELECT, JOIN, GROUP BY, and transaction queries for the student payment schema.',
        15,
        '2026-08-03',
        'sql-lab-sheet.pdf',
      ],
      [
        'asg-003',
        'sec-cse331-6a',
        'u-tea-001',
        'Software Requirements Document',
        'Prepare SRS sections for the library seat booking module including functional and non-functional requirements.',
        25,
        '2026-08-05',
        'srs-template.docx',
      ],
      [
        'asg-004',
        'sec-cse331-6a',
        'u-tea-001',
        'Use Case and Sequence Diagram Set',
        'Model teacher attendance marking and student support ticket workflows.',
        20,
        '2026-08-10',
        'uml-checklist.pdf',
      ],
      [
        'asg-005',
        'sec-cse341-6a',
        'u-tea-005',
        'Operating Systems Scheduling Report',
        'Compare FCFS, SJF, Priority, and Round Robin scheduling for the given process table.',
        20,
        '2026-08-01',
        'os-process-table.xlsx',
      ],
      [
        'asg-006',
        'sec-cse231-6a',
        'u-tea-002',
        'Binary Search Tree Implementation',
        'Implement insert, delete, traversal, and height calculation with complexity notes.',
        20,
        '2026-07-30',
        'bst-rubric.pdf',
      ],
      [
        'asg-007',
        'sec-cse410-5b',
        'u-tea-002',
        'A* Search Route Planning',
        'Use A* to find shortest path between campus buildings using heuristic estimates.',
        25,
        '2026-08-12',
        'campus-graph.csv',
      ],
      [
        'asg-008',
        'sec-cse420-5b',
        'u-tea-005',
        'Subnetting Lab Report',
        'Design subnets for department labs and justify address allocation.',
        15,
        '2026-08-02',
        'network-topology.png',
      ],
      [
        'asg-009',
        'sec-cse425-5b',
        'u-tea-008',
        'Responsive Portal UI Review',
        'Audit a university portal screen for overflow, tap targets, and responsive layout quality.',
        15,
        '2026-08-07',
        'ui-audit-template.pdf',
      ],
      [
        'asg-010',
        'sec-eee201-6a',
        'u-tea-003',
        'Circuit Analysis Problem Set',
        'Solve KCL, KVL, Thevenin, and Norton equivalent circuit problems.',
        20,
        '2026-08-04',
        'circuit-problems.pdf',
      ],
      [
        'asg-011',
        'sec-eee305-5b',
        'u-tea-010',
        'Digital Logic Design Sheet',
        'Design combinational circuits using Karnaugh maps and verify truth tables.',
        20,
        '2026-08-08',
        'logic-design-sheet.pdf',
      ],
      [
        'asg-012',
        'sec-bus201-1a',
        'u-tea-004',
        'Management Case Analysis',
        'Analyze leadership decisions in a Bangladesh telecom operations case.',
        15,
        '2026-08-06',
        'case-study.pdf',
      ],
      [
        'asg-013',
        'sec-bus321-3a',
        'u-tea-009',
        'Financial Statement Exercise',
        'Prepare journal entries and an income statement from transaction records.',
        20,
        '2026-08-09',
        'accounts-workbook.xlsx',
      ],
      [
        'asg-014',
        'sec-eng205-6a',
        'u-tea-006',
        'Professional Email Portfolio',
        'Draft inquiry, apology, progress update, and meeting summary emails.',
        10,
        '2026-07-29',
        'email-rubric.pdf',
      ],
      [
        'asg-015',
        'sec-ce211-2a',
        'u-tea-007',
        'Truss Analysis Worksheet',
        'Calculate support reactions and member forces for two truss diagrams.',
        20,
        '2026-08-11',
        'truss-diagrams.pdf',
      ],
    ];
    return items.map((item) {
      return DemoAssignment(
        id: item[0] as String,
        sectionId: item[1] as String,
        teacherId: item[2] as String,
        title: item[3] as String,
        instructions: item[4] as String,
        totalMarks: item[5] as int,
        publishedAt: DateTime(2026, 7, 20),
        dueAt: DateTime.parse(item[6] as String),
        status: 'published',
        attachments: [item[7] as String],
      );
    }).toList();
  }

  static List<DemoSubmission> _submissions() {
    return [
      DemoSubmission(
        id: 'sub-001',
        assignmentId: 'asg-001',
        studentId: 'u-stu-001',
        note:
            'Submitted dependency table, 1NF to 3NF conversion, and ERD explanation.',
        fileName: 'Nayem_CSE315_Normalization.pdf',
        status: 'graded',
        submittedAt: DateTime(2026, 7, 24, 20, 12),
        marks: 18,
        feedback:
            'Strong dependency explanation. Add one paragraph on transitive dependency removal.',
      ),
      DemoSubmission(
        id: 'sub-002',
        assignmentId: 'asg-003',
        studentId: 'u-stu-001',
        note: 'Initial SRS draft with scope, actors, and validation rules.',
        fileName: 'Nayem_SRS_Draft.docx',
        status: 'submitted',
        submittedAt: DateTime(2026, 7, 24, 21, 5),
      ),
      DemoSubmission(
        id: 'sub-003',
        assignmentId: 'asg-001',
        studentId: 'u-stu-002',
        note: 'Attached ERD and normalization notes.',
        fileName: 'Sabbir_DBMS_3NF.pdf',
        status: 'submitted',
        submittedAt: DateTime(2026, 7, 24, 18, 20),
      ),
      DemoSubmission(
        id: 'sub-004',
        assignmentId: 'asg-001',
        studentId: 'u-stu-004',
        note: 'Rechecked BCNF explanation after class discussion.',
        fileName: 'Tasnim_Normalization.pdf',
        status: 'reviewed',
        submittedAt: DateTime(2026, 7, 23, 22, 15),
        marks: 17,
        feedback:
            'Good analysis. The BCNF part is beyond requirement and nicely done.',
      ),
      DemoSubmission(
        id: 'sub-005',
        assignmentId: 'asg-006',
        studentId: 'u-stu-013',
        note: 'BST implementation with unit test screenshots.',
        fileName: 'Rakibul_BST.zip',
        status: 'submitted',
        submittedAt: DateTime(2026, 7, 24, 16, 30),
      ),
    ];
  }

  static List<DemoQuiz> _quizzes() {
    return [
      _quiz(
        'quiz-001',
        'sec-cse315-6a',
        'u-tea-001',
        'DBMS Normalization Quiz',
        'Answer based on functional dependencies and normal forms.',
        20,
        '2026-07-24',
        '2026-08-02',
        _dbmsQuestions(),
      ),
      _quiz(
        'quiz-002',
        'sec-cse315-6a',
        'u-tea-001',
        'SQL Transaction Quiz',
        'Focus on joins, isolation, and transaction consistency.',
        20,
        '2026-07-25',
        '2026-08-05',
        _sqlQuestions(),
      ),
      _quiz(
        'quiz-003',
        'sec-cse331-6a',
        'u-tea-001',
        'Software Requirements Quiz',
        'Review SRS, actors, and non-functional requirements.',
        20,
        '2026-07-25',
        '2026-08-06',
        _seQuestions(),
      ),
      _quiz(
        'quiz-004',
        'sec-cse341-6a',
        'u-tea-005',
        'CPU Scheduling Quiz',
        'Calculate waiting time and identify scheduling behavior.',
        20,
        '2026-07-26',
        '2026-08-04',
        _osQuestions(),
      ),
      _quiz(
        'quiz-005',
        'sec-cse231-6a',
        'u-tea-002',
        'Data Structures Quiz',
        'Trace tree and stack operations carefully.',
        20,
        '2026-07-26',
        '2026-08-05',
        _dsQuestions(),
      ),
      _quiz(
        'quiz-006',
        'sec-cse410-5b',
        'u-tea-002',
        'Search Algorithms Quiz',
        'Use state-space search concepts from class.',
        20,
        '2026-07-27',
        '2026-08-08',
        _aiQuestions(),
      ),
      _quiz(
        'quiz-007',
        'sec-cse420-5b',
        'u-tea-005',
        'Networking Basics Quiz',
        'Review IP addressing, routing, and transport protocols.',
        20,
        '2026-07-27',
        '2026-08-09',
        _networkQuestions(),
      ),
      _quiz(
        'quiz-008',
        'sec-eee201-6a',
        'u-tea-003',
        'Circuit Laws Quiz',
        'Solve using KCL, KVL, and equivalent resistance concepts.',
        20,
        '2026-07-27',
        '2026-08-06',
        _circuitQuestions(),
      ),
      _quiz(
        'quiz-009',
        'sec-eng205-6a',
        'u-tea-006',
        'Business Communication Quiz',
        'Choose the professional communication response.',
        20,
        '2026-07-28',
        '2026-08-07',
        _communicationQuestions(),
      ),
      _quiz(
        'quiz-010',
        'sec-bus321-3a',
        'u-tea-009',
        'Accounting Basics Quiz',
        'Classify entries and statements correctly.',
        20,
        '2026-07-28',
        '2026-08-10',
        _accountingQuestions(),
      ),
    ];
  }

  static DemoQuiz _quiz(
    String id,
    String sectionId,
    String teacherId,
    String title,
    String instructions,
    num marks,
    String open,
    String close,
    List<DemoQuizQuestion> questions,
  ) {
    return DemoQuiz(
      id: id,
      sectionId: sectionId,
      teacherId: teacherId,
      title: title,
      instructions: instructions,
      totalMarks: marks,
      durationMinutes: 25,
      opensAt: DateTime.parse(open),
      closesAt: DateTime.parse(close),
      status: 'published',
      questions: questions,
    );
  }

  static List<DemoQuizQuestion> _questionSet(
    String prefix,
    List<List<String>> rows,
  ) {
    return rows.asMap().entries.map((entry) {
      final index = entry.key;
      final row = entry.value;
      return DemoQuizQuestion(
        id: '$prefix-q${index + 1}',
        question: row[0],
        marks: 4,
        correctOptionId: '$prefix-q${index + 1}-o1',
        options: [
          DemoQuizOption(id: '$prefix-q${index + 1}-o1', text: row[1]),
          DemoQuizOption(id: '$prefix-q${index + 1}-o2', text: row[2]),
          DemoQuizOption(id: '$prefix-q${index + 1}-o3', text: row[3]),
          DemoQuizOption(id: '$prefix-q${index + 1}-o4', text: row[4]),
        ],
      );
    }).toList();
  }

  static List<DemoQuizQuestion> _dbmsQuestions() => _questionSet('dbms', [
    [
      'Which normal form removes partial dependency from a relation?',
      'Second Normal Form',
      'First Normal Form',
      'Boyce-Codd Normal Form',
      'Domain-Key Normal Form',
    ],
    [
      'A foreign key mainly helps enforce which property?',
      'Referential integrity',
      'Physical file compression',
      'User interface validation',
      'Network encryption',
    ],
    [
      'Which SQL clause filters grouped rows after aggregation?',
      'HAVING',
      'WHERE',
      'ORDER BY',
      'DISTINCT',
    ],
    [
      'What does a candidate key represent?',
      'A minimal attribute set that uniquely identifies tuples',
      'A column that stores encrypted values',
      'A field generated only by the database server',
      'A duplicate index for faster search',
    ],
    [
      'Which transaction property guarantees all-or-nothing execution?',
      'Atomicity',
      'Isolation',
      'Durability',
      'Consistency',
    ],
  ]);

  static List<DemoQuizQuestion> _sqlQuestions() => _questionSet('sql', [
    [
      'Which join returns rows that match in both tables?',
      'INNER JOIN',
      'FULL OUTER JOIN',
      'CROSS JOIN',
      'SELF JOIN only',
    ],
    [
      'Which command permanently stores transaction changes?',
      'COMMIT',
      'ROLLBACK',
      'SAVEPOINT',
      'EXPLAIN',
    ],
    [
      'A transaction isolation level mainly controls what?',
      'Visibility of concurrent changes',
      'Table name length',
      'Backup frequency',
      'Column display order',
    ],
    [
      'Which index is usually suitable for exact lookup on student_id?',
      'B-tree index',
      'Bitmap image file',
      'Heap scan setting',
      'CSV header',
    ],
    [
      'What does GROUP BY require for selected non-aggregated columns?',
      'They must be grouped or functionally dependent',
      'They must be hidden',
      'They must be nullable',
      'They must be text only',
    ],
  ]);

  static List<DemoQuizQuestion> _seQuestions() => _questionSet('se', [
    [
      'Which SRS quality means every requirement can be verified?',
      'Testability',
      'Aesthetic design',
      'Code minification',
      'Database sharding',
    ],
    [
      'A use case primarily describes interaction between what?',
      'Actor and system',
      'Compiler and linker',
      'Router and switch',
      'Table and index only',
    ],
    [
      'Which is a non-functional requirement?',
      'The portal loads dashboard data within two seconds',
      'Student submits assignment note',
      'Teacher edits a quiz title',
      'Admin approves an event',
    ],
    [
      'Which diagram best shows message order between objects?',
      'Sequence diagram',
      'ER diagram',
      'Network topology',
      'Pie chart',
    ],
    [
      'What is scope creep?',
      'Uncontrolled expansion of project requirements',
      'Reducing test cases intentionally',
      'Migrating code to a new branch',
      'Writing comments in source files',
    ],
  ]);

  static List<DemoQuizQuestion> _osQuestions() => _questionSet('os', [
    [
      'Round Robin scheduling depends heavily on which value?',
      'Time quantum',
      'Disk cylinder size',
      'Page table base address',
      'Compiler optimization level',
    ],
    [
      'Which metric measures time from process arrival to completion?',
      'Turnaround time',
      'Burst time only',
      'Interrupt vector',
      'Memory alignment',
    ],
    [
      'A deadlock needs mutual exclusion, hold and wait, no preemption, and what?',
      'Circular wait',
      'Packet loss',
      'Schema lock',
      'Clock skew only',
    ],
    [
      'Which algorithm can suffer from starvation?',
      'Priority scheduling',
      'First Come First Served',
      'Round Robin with fair quantum',
      'Simple FIFO queue with no priority',
    ],
    [
      'What does context switching do?',
      'Saves one process state and restores another',
      'Formats a disk partition',
      'Normalizes a database table',
      'Allocates an email address',
    ],
  ]);

  static List<DemoQuizQuestion> _dsQuestions() => _questionSet('ds', [
    [
      'In a binary search tree, left child values are generally what?',
      'Smaller than the node value',
      'Always equal to the root',
      'Stored by insertion time only',
      'Randomly assigned',
    ],
    [
      'Which structure is used by function call management?',
      'Stack',
      'Queue',
      'Graph',
      'Hash table only',
    ],
    [
      'Average search time in a balanced BST is what?',
      'O(log n)',
      'O(n squared)',
      'O(1) for every case',
      'O(n log n) always',
    ],
    [
      'Which traversal visits left subtree, root, then right subtree?',
      'Inorder',
      'Preorder',
      'Postorder',
      'Level order',
    ],
    [
      'A queue follows which access rule?',
      'First in first out',
      'Last in first out',
      'Highest value first',
      'Random access only',
    ],
  ]);

  static List<DemoQuizQuestion> _aiQuestions() => _questionSet('ai', [
    [
      'A* search combines path cost with what?',
      'Heuristic estimate',
      'Screen width',
      'Database index count',
      'Compiler warnings',
    ],
    [
      'Which heuristic property keeps A* optimal?',
      'Admissibility',
      'Verbosity',
      'Redundancy',
      'Serialization',
    ],
    [
      'What is a state space?',
      'All reachable configurations of a problem',
      'Only the final answer',
      'A Flutter widget tree',
      'A payment receipt list',
    ],
    [
      'Greedy best-first search chooses nodes by what?',
      'Heuristic value',
      'Student ID order',
      'File size',
      'Network port',
    ],
    [
      'A confusion matrix is used to evaluate what?',
      'Classification results',
      'Database normalization',
      'Circuit resistance',
      'Tuition waiver',
    ],
  ]);

  static List<DemoQuizQuestion> _networkQuestions() => _questionSet('net', [
    [
      'Which protocol provides reliable ordered delivery?',
      'TCP',
      'UDP',
      'ICMP',
      'ARP only',
    ],
    [
      'A subnet mask helps determine what?',
      'Network and host portions of an IP address',
      'Screen brightness',
      'Database password length',
      'PDF page count',
    ],
    [
      'DNS primarily resolves what?',
      'Domain names to IP addresses',
      'Course marks to grades',
      'User roles to colors',
      'Invoices to receipts',
    ],
    [
      'Which layer handles routing between networks?',
      'Network layer',
      'Presentation layer',
      'Application form layer',
      'Power layer',
    ],
    [
      'What does latency measure?',
      'Delay before data transfer is observed',
      'Total course credits',
      'Assignment marks',
      'Number of comments',
    ],
  ]);

  static List<DemoQuizQuestion> _circuitQuestions() => _questionSet('ckt', [
    [
      'Kirchhoff current law is based on conservation of what?',
      'Charge',
      'Mass',
      'Momentum',
      'Database rows',
    ],
    [
      'Equivalent resistance of series resistors is calculated by what?',
      'Adding the resistor values',
      'Multiplying by voltage only',
      'Taking the smallest value',
      'Ignoring all but one resistor',
    ],
    [
      'Thevenin equivalent contains a voltage source and what?',
      'Series resistance',
      'Parallel capacitor only',
      'Database view',
      'Open switch only',
    ],
    [
      'Ohm law relates voltage, current, and what?',
      'Resistance',
      'Frequency only',
      'Capacitance only',
      'Magnetic flux only',
    ],
    [
      'In a parallel circuit, voltage across each branch is generally what?',
      'The same',
      'Always zero',
      'Always doubled',
      'Dependent on branch color',
    ],
  ]);

  static List<DemoQuizQuestion> _communicationQuestions() =>
      _questionSet('comm', [
        [
          'A professional email subject should be what?',
          'Specific and concise',
          'Empty for formality',
          'All lowercase jokes',
          'A copied paragraph',
        ],
        [
          'Which tone is best for a deadline extension request?',
          'Respectful and specific',
          'Demanding and vague',
          'Sarcastic',
          'Unrelated to the course',
        ],
        [
          'A meeting summary should include decisions and what else?',
          'Action items with owners',
          'Only greetings',
          'Password lists',
          'Random quotes',
        ],
        [
          'Which sentence is clearest?',
          'Please confirm whether the revised deadline is August 3.',
          'Deadline thing maybe?',
          'You know what I mean.',
          'Need it fast.',
        ],
        [
          'Proofreading helps reduce what?',
          'Ambiguity and errors',
          'Course credits',
          'Network latency',
          'Tuition due',
        ],
      ]);

  static List<DemoQuizQuestion> _accountingQuestions() => _questionSet('acct', [
    [
      'An asset account normally has what balance?',
      'Debit',
      'Credit only',
      'Zero always',
      'No balance',
    ],
    [
      'Revenue is recognized when what generally happens?',
      'It is earned',
      'A desk is purchased',
      'A class starts',
      'A password changes',
    ],
    [
      'Which statement reports financial position?',
      'Balance sheet',
      'Class routine',
      'Forum thread',
      'Attendance sheet',
    ],
    [
      'Depreciation allocates cost over what?',
      'Useful life',
      'One email thread',
      'Quiz duration',
      'Student ID digits',
    ],
    [
      'A journal entry must keep debits and credits what?',
      'Equal',
      'Hidden',
      'Alphabetical',
      'In separate semesters',
    ],
  ]);

  static List<DemoQuizAttempt> _quizAttempts() {
    return [
      DemoQuizAttempt(
        id: 'qat-001',
        quizId: 'quiz-001',
        studentId: 'u-stu-001',
        status: 'submitted',
        submittedAt: DateTime(2026, 7, 24, 22, 10),
        score: 16,
        answers: {'dbms-q1': 'dbms-q1-o1', 'dbms-q2': 'dbms-q2-o1'},
      ),
      DemoQuizAttempt(
        id: 'qat-002',
        quizId: 'quiz-003',
        studentId: 'u-stu-001',
        status: 'submitted',
        submittedAt: DateTime(2026, 7, 24, 22, 25),
        score: 14,
      ),
      DemoQuizAttempt(
        id: 'qat-003',
        quizId: 'quiz-001',
        studentId: 'u-stu-002',
        status: 'submitted',
        submittedAt: DateTime(2026, 7, 24, 20, 48),
        score: 18,
      ),
    ];
  }

  static List<DemoExamSchedule> _examSchedules(List<DemoSection> sections) {
    final examTypes = ['Midterm', 'Final', 'Supplementary'];
    return sections.asMap().entries.map((entry) {
      final index = entry.key;
      final section = entry.value;
      final type = examTypes[index % examTypes.length];
      final isFinal = type == 'Final';
      final isSupplementary = type == 'Supplementary';
      return DemoExamSchedule(
        id: 'exam-${(index + 1).toString().padLeft(3, '0')}',
        courseId: section.courseId,
        sectionId: section.id,
        examType: type,
        room: 'Room ${501 + index % 9}',
        date: DateTime(
          2026,
          isFinal ? 8 : 7,
          isFinal ? 1 + index % 10 : 25 + index % 5,
        ),
        start: index.isEven ? '10:00 AM' : '02:00 PM',
        end: index.isEven ? '12:00 PM' : '04:00 PM',
        invigilatorId: 'u-tea-${((index % 10) + 1).toString().padLeft(3, '0')}',
        admitCardStatus: index % 4 == 0 ? 'Pending Clearance' : 'Ready',
        resultSubmissionStatus: isSupplementary
            ? 'Awaiting Submission'
            : index % 3 == 0
            ? 'Submitted'
            : 'Awaiting Submission',
        resultApprovalStatus: index % 5 == 0 ? 'Approved' : 'Awaiting Review',
        resultPublicationStatus: index % 6 == 0 ? 'Published' : 'Not Published',
        supplementaryCases: isSupplementary ? 2 + index % 5 : index % 3,
      );
    }).toList();
  }

  static List<DemoStudentRequest> _studentRequests() {
    final requestTypes = [
      ('Transcript', 'office-exams'),
      ('Provisional Certificate', 'office-registrar'),
      ('Academic Certificate', 'office-registrar'),
      ('Recommendation/Verification', 'office-registrar'),
      ('Student ID replacement', 'office-admission'),
      ('Registration correction', 'office-registrar'),
      ('Course registration issue', 'office-program'),
      ('Payment correction', 'office-accounts'),
      ('Result correction', 'office-exams'),
      ('Supplementary exam request', 'office-exams'),
    ];
    final statuses = [
      'Submitted',
      'Under Review',
      'Additional Information Required',
      'Approved',
      'Processing',
      'Ready',
      'Completed',
      'Rejected',
    ];
    return List.generate(36, (offset) {
      final type = requestTypes[offset % requestTypes.length];
      final studentNo = offset % 40 + 1;
      final status = statuses[offset % statuses.length];
      return DemoStudentRequest(
        id: 'req-${(offset + 1).toString().padLeft(3, '0')}',
        studentId: 'u-stu-${studentNo.toString().padLeft(3, '0')}',
        type: type.$1,
        submittedAt: DateTime(2026, 7, 2 + offset % 23, 10 + offset % 7),
        assignedOfficeId: type.$2,
        priority: offset % 7 == 0
            ? 'Urgent'
            : offset % 3 == 0
            ? 'High'
            : 'Normal',
        status: status,
        notes:
            '$status request routed to ${type.$2.replaceAll('office-', '').toUpperCase()} workflow.',
        timeline: [
          'Submitted by student on July ${(2 + offset % 23).toString().padLeft(2, '0')}, 2026',
          if (status != 'Submitted') 'Assigned office reviewed the request',
          if (status == 'Ready' || status == 'Completed')
            'Document prepared for collection',
        ],
        updatedAt: DateTime(2026, 7, 3 + offset % 22, 14),
      );
    });
  }

  static List<DemoAdmissionApplication> _admissions() {
    final programIds = [
      'program-cse-bsc',
      'program-eee-bsc',
      'program-ce-bsc',
      'program-bba',
      'program-eng-ba',
      'program-law-llb',
      'program-eco-bss',
    ];
    final firstNames = [
      'Mahir',
      'Sadia',
      'Nafisa',
      'Riyad',
      'Tamanna',
      'Shafin',
      'Jarin',
      'Hasib',
    ];
    final stages = [
      'New',
      'Documents Pending',
      'Under Review',
      'Eligible',
      'Approved',
      'Rejected',
      'Payment Pending',
      'Registered',
    ];
    return List.generate(48, (offset) {
      final stage = stages[offset % stages.length];
      return DemoAdmissionApplication(
        id: 'app-${(offset + 1).toString().padLeft(4, '0')}',
        applicantName:
            '${firstNames[offset % firstNames.length]} ${offset.isEven ? 'Rahman' : 'Islam'}',
        programId: programIds[offset % programIds.length],
        contact: '+88019${(41000000 + offset * 3711).toString().substring(1)}',
        previousEducation: offset % 5 == 0
            ? 'Diploma in Engineering'
            : 'HSC, Science group',
        applicationDate: DateTime(2026, 7, 1 + offset % 24),
        documents: {
          'Photo': true,
          'Transcript': offset % 4 != 0,
          'Certificate': offset % 5 != 0,
          'NID/Birth certificate': offset % 6 != 0,
        },
        stage: stage,
        paymentStatus: stage == 'Registered'
            ? 'Paid'
            : offset % 3 == 0
            ? 'Pending'
            : 'Unpaid',
      );
    });
  }

  static List<DemoLostFoundItem> _lostFoundItems() {
    final rows = [
      (
        'Lost',
        'Black Casio scientific calculator',
        'Name sticker on the back, last used after EEE lab.',
        'EEE Laboratory',
        'u-stu-010',
        'Open',
      ),
      (
        'Found',
        'Student ID card found near CSE Lab 2',
        'ID card belongs to a Spring 2026 CSE student.',
        'CSE Lab 2',
        'u-admstaff-010',
        'Matched',
      ),
      (
        'Found',
        'Blue notebook with DBMS notes',
        'Contains normalization notes and an assignment checklist.',
        'Library second floor',
        'u-stu-004',
        'Open',
      ),
      (
        'Lost',
        'USB flash drive',
        'Silver 32GB flash drive with cap missing.',
        'Room 604',
        'u-tea-001',
        'Open',
      ),
      (
        'Found',
        'Wallet with transport card',
        'No cash reported, owner can identify card details.',
        'Admission office lobby',
        'u-admstaff-004',
        'Returned',
      ),
      (
        'Lost',
        'Civil drawing scale set',
        'Transparent scale set in a blue pouch.',
        'Civil drawing room',
        'u-stu-018',
        'Closed',
      ),
    ];

    return rows.asMap().entries.map((entry) {
      final index = entry.key;
      final row = entry.value;
      return DemoLostFoundItem(
        id: 'lf-${(index + 1).toString().padLeft(3, '0')}',
        type: row.$1,
        title: row.$2,
        description: row.$3,
        location: row.$4,
        reporterId: row.$5,
        status: row.$6,
        reportedAt: DateTime(2026, 7, 20 + index),
        contact: 'Student Service Desk',
        matchedItemId: row.$6 == 'Matched' ? 'lf-001' : null,
        claimNote: row.$6 == 'Returned'
            ? 'Owner verified identity and collected from Student Affairs.'
            : null,
      );
    }).toList();
  }

  static List<DemoNotice> _notices() {
    final titles = [
      'Spring 2026 midterm routine published',
      'CSE lab access schedule updated',
      'Library extended hours during exam week',
      'Tuition payment deadline for Spring 2026',
      'Programming contest registration opened',
      'Career seminar seat confirmation',
      'DBMS assignment rubric updated',
      'Software Engineering project group list',
      'Transport route timing adjustment',
      'Blood donation campaign volunteer briefing',
      'Scholarship application window opened',
      'Student ID card collection notice',
      'Course add-drop deadline reminder',
      'Research methodology seminar invitation',
      'Cybersecurity workshop lab requirement',
      'Final exam form fill-up instructions',
      'Campus Wi-Fi maintenance notice',
      'Robotics club orientation',
      'Convocation photo booth schedule',
      'Academic advising slots for CSE 6A',
    ];
    return titles.asMap().entries.map((entry) {
      return DemoNotice(
        id: 'notice-${(entry.key + 1).toString().padLeft(3, '0')}',
        title: entry.value,
        body:
            'Please check the portal details and contact your department office if you need assistance.',
        authorId: entry.key % 4 == 0
            ? 'u-adm-001'
            : entry.key % 3 == 0
            ? 'u-admstaff-001'
            : 'u-tea-001',
        target: entry.key % 5 == 0 ? 'all' : 'students',
        publishedAt: DateTime(2026, 7, 2 + entry.key, 10, 30),
        sectionId: entry.key == 6 || entry.key == 7 ? 'sec-cse315-6a' : null,
        category: entry.key % 4 == 0
            ? 'Academic'
            : entry.key % 4 == 1
            ? 'Payment'
            : entry.key % 4 == 2
            ? 'Event'
            : 'Administration',
        audience: entry.key % 5 == 0 ? 'All' : 'Students',
        expiryDate: DateTime(2026, 8, 10 + entry.key % 12),
        priority: entry.key % 6 == 0 ? 'High' : 'Normal',
        attachmentName: entry.key % 3 == 0
            ? 'notice-${entry.key + 1}.pdf'
            : null,
        status: 'Published',
      );
    }).toList();
  }

  static List<DemoEvent> _events() {
    final rows = [
      [
        'evt-001',
        'EUB Programming Contest',
        'Two-hour onsite contest for CSE students with team prizes.',
        '2026-08-02',
        'CSE Lab 1',
        'Programming Club',
        120,
      ],
      [
        'evt-002',
        'CSE Career Seminar',
        'Industry engineers discuss backend, mobile, and QA career tracks.',
        '2026-08-05',
        'Auditorium',
        'CSE Department',
        180,
      ],
      [
        'evt-003',
        'Blood Donation Campaign',
        'Volunteer-led campus drive with partner hospital support.',
        '2026-08-07',
        'Ground Floor Lobby',
        'Social Welfare Club',
        160,
      ],
      [
        'evt-004',
        'Cultural Night 2026',
        'Music, recitation, drama, and dance performances by students.',
        '2026-08-12',
        'Central Auditorium',
        'Cultural Club',
        350,
      ],
      [
        'evt-005',
        'Robotics Workshop',
        'Hands-on Arduino and line-follower robot workshop.',
        '2026-08-14',
        'Robotics Lab',
        'Robotics Club',
        60,
      ],
      [
        'evt-006',
        'Research Methodology Seminar',
        'Guidance on literature review, citations, and research ethics.',
        '2026-08-18',
        'Seminar Room 401',
        'IQAC and Program Coordination',
        100,
      ],
      [
        'evt-007',
        'Cybersecurity Awareness Session',
        'Password safety, phishing prevention, and secure coding basics.',
        '2026-08-20',
        'Room 602',
        'CSE Department',
        90,
      ],
      [
        'evt-008',
        'Debate Championship Preliminary',
        'Inter-department debate preliminary round.',
        '2026-08-23',
        'Conference Hall',
        'Debating Club',
        120,
      ],
      [
        'evt-009',
        'Photography Walk: Old Dhaka',
        'Guided weekend field session for campus photographers.',
        '2026-08-28',
        'Main Gate',
        'Photography Club',
        45,
      ],
      [
        'evt-010',
        'Startup Pitch Practice',
        'Students practice short startup pitches with faculty mentors.',
        '2026-09-01',
        'Business Lab',
        'Business Club',
        75,
      ],
    ];
    return rows.map((row) {
      return DemoEvent(
        id: row[0] as String,
        title: row[1] as String,
        description: row[2] as String,
        date: DateTime.parse(row[3] as String),
        venue: row[4] as String,
        organizer: row[5] as String,
        capacity: row[6] as int,
        status: 'published',
        time: (rows.indexOf(row).isEven ? '10:30 AM' : '03:00 PM'),
        audience: rows.indexOf(row) % 3 == 0 ? 'All' : 'Students',
      );
    }).toList();
  }

  static List<DemoEventRegistration> _eventRegistrations() {
    return [
      DemoEventRegistration(
        id: 'ereg-001',
        eventId: 'evt-001',
        studentId: 'u-stu-001',
        registeredAt: DateTime(2026, 7, 21),
        status: 'registered',
      ),
      DemoEventRegistration(
        id: 'ereg-002',
        eventId: 'evt-002',
        studentId: 'u-stu-001',
        registeredAt: DateTime(2026, 7, 22),
        status: 'registered',
      ),
      DemoEventRegistration(
        id: 'ereg-003',
        eventId: 'evt-001',
        studentId: 'u-stu-002',
        registeredAt: DateTime(2026, 7, 21),
        status: 'registered',
      ),
      DemoEventRegistration(
        id: 'ereg-004',
        eventId: 'evt-005',
        studentId: 'u-stu-004',
        registeredAt: DateTime(2026, 7, 23),
        status: 'registered',
      ),
      DemoEventRegistration(
        id: 'ereg-005',
        eventId: 'evt-008',
        studentId: 'u-stu-006',
        registeredAt: DateTime(2026, 7, 24),
        status: 'registered',
      ),
    ];
  }

  static List<DemoClub> _clubs() {
    return [
      DemoClub(
        id: 'club-programming',
        name: 'Programming Club',
        description:
            'Competitive programming, hackathons, and weekly problem solving.',
        advisorId: 'u-tea-001',
        presidentId: 'u-stu-002',
      ),
      DemoClub(
        id: 'club-robotics',
        name: 'Robotics Club',
        description:
            'Line follower, IoT, automation, and embedded systems projects.',
        advisorId: 'u-tea-003',
        presidentId: 'u-stu-004',
      ),
      DemoClub(
        id: 'club-debate',
        name: 'Debating Club',
        description:
            'Public speaking, parliamentary debate, and inter-university competitions.',
        advisorId: 'u-tea-006',
        presidentId: 'u-stu-006',
      ),
      DemoClub(
        id: 'club-cultural',
        name: 'Cultural Club',
        description: 'Music, drama, recitation, dance, and campus festivals.',
        advisorId: 'u-tea-004',
        presidentId: 'u-stu-008',
      ),
      DemoClub(
        id: 'club-photography',
        name: 'Photography Club',
        description:
            'Photo walks, exhibitions, campus documentation, and editing workshops.',
        advisorId: 'u-tea-007',
        presidentId: 'u-stu-010',
      ),
    ];
  }

  static List<DemoClubMembership> _clubMemberships() {
    return [
      DemoClubMembership(
        id: 'cm-001',
        clubId: 'club-programming',
        studentId: 'u-stu-001',
        status: 'active',
        joinedAt: DateTime(2026, 2, 12),
      ),
      DemoClubMembership(
        id: 'cm-002',
        clubId: 'club-programming',
        studentId: 'u-stu-002',
        status: 'active',
        joinedAt: DateTime(2026, 2, 10),
      ),
      DemoClubMembership(
        id: 'cm-003',
        clubId: 'club-robotics',
        studentId: 'u-stu-004',
        status: 'active',
        joinedAt: DateTime(2026, 3, 6),
      ),
      DemoClubMembership(
        id: 'cm-004',
        clubId: 'club-debate',
        studentId: 'u-stu-006',
        status: 'active',
        joinedAt: DateTime(2026, 3, 9),
      ),
      DemoClubMembership(
        id: 'cm-005',
        clubId: 'club-photography',
        studentId: 'u-stu-010',
        status: 'active',
        joinedAt: DateTime(2026, 4, 2),
      ),
    ];
  }

  static List<DemoForumCategory> _forumCategories() {
    return const [
      DemoForumCategory(id: 'cat-general', name: 'General Discussion'),
      DemoForumCategory(id: 'cat-academics', name: 'Academics'),
      DemoForumCategory(id: 'cat-course-help', name: 'Course Help'),
      DemoForumCategory(id: 'cat-campus', name: 'Campus Life'),
      DemoForumCategory(id: 'cat-programming', name: 'Programming'),
      DemoForumCategory(id: 'cat-career', name: 'Career'),
      DemoForumCategory(id: 'cat-events', name: 'Events'),
      DemoForumCategory(id: 'cat-clubs', name: 'Clubs'),
    ];
  }

  static List<DemoForumPost> _forumPosts() {
    final rows = [
      [
        'cat-course-help',
        'Does anyone have the DBMS normalization notes from today?',
        'Dr. Farhan explained partial dependency with a payment table example. I missed the last ten minutes and need the final dependency set.',
      ],
      [
        'cat-academics',
        'Confirmed deadline for the Software Engineering SRS?',
        'Sir mentioned the assignment deadline may be extended. Has it been confirmed in the portal or only discussed in class?',
      ],
      [
        'cat-programming',
        'Team for upcoming programming contest',
        'I am looking for two teammates comfortable with graph problems and dynamic programming for the EUB contest.',
      ],
      [
        'cat-campus',
        'Quiet place for online viva on campus',
        'Which room is usually free after 2 PM for a short online viva? The library discussion corner was crowded today.',
      ],
      [
        'cat-events',
        'CSE Career Seminar registration issue',
        'The event says registered on my dashboard but the confirmation email did not arrive. Is the portal confirmation enough?',
      ],
      [
        'cat-clubs',
        'Robotics workshop kit list',
        'For the Arduino workshop, should we bring our own jumper wires and battery pack or will the club provide them?',
      ],
      [
        'cat-course-help',
        'Operating Systems Round Robin calculation',
        'For process P3 arriving at time 4, do we count waiting time from arrival or first queue entry after preemption?',
      ],
      [
        'cat-general',
        'Academic advising slot exchange',
        'I have Wednesday 11 AM advising but a lab at the same time. Can anyone from Tuesday afternoon swap?',
      ],
      [
        'cat-programming',
        'SQL practice sheet query 7 discussion',
        'Query 7 asks for students with unpaid invoices and submitted assignments. I think it needs two joins and a HAVING clause.',
      ],
      [
        'cat-campus',
        'Bus timing from Mirpur route',
        'The morning bus reached ten minutes late twice this week. Did the transport office announce a timing change?',
      ],
      [
        'cat-career',
        'Internship CV review group',
        'A few of us are planning a peer CV review after the career seminar. Anyone from CSE 6A interested?',
      ],
      [
        'cat-academics',
        'Midterm routine conflict with lab',
        'The draft midterm routine overlaps with CSE 315 lab for our section. Should we inform department office as a group?',
      ],
      [
        'cat-course-help',
        'BST delete case with two children',
        'When deleting a node with two children, our teacher used inorder successor. Is predecessor also accepted if implemented consistently?',
      ],
      [
        'cat-events',
        'Blood donation volunteer briefing time',
        'The event page says 10 AM but the notice says 11 AM. Which time should volunteers follow?',
      ],
      [
        'cat-clubs',
        'Photography walk registration closed early',
        'I planned to register tonight but it says full. Will the club open a waiting list?',
      ],
      [
        'cat-programming',
        'Need graph problem recommendations',
        'I solved basic BFS and DFS problems. What should I practice next before the contest?',
      ],
      [
        'cat-general',
        'Library seat booking during final week',
        'Does the library require advance seat booking during final exam week or can we enter directly with ID card?',
      ],
      [
        'cat-campus',
        'Wi-Fi issue near CSE Lab 2',
        'The campus Wi-Fi drops during DBMS lab. Is anyone else facing this or is it my device?',
      ],
      [
        'cat-career',
        'Backend portfolio project ideas',
        'For internship applications, would a university support ticket system be a strong backend portfolio project?',
      ],
      [
        'cat-course-help',
        'EEE 201 Thevenin equivalent step',
        'Can someone explain why the load resistor is removed before finding Thevenin voltage?',
      ],
      [
        'cat-academics',
        'Scholarship application transcript upload',
        'The scholarship form asks for an updated transcript. Can we upload the portal result screenshot for now?',
      ],
      [
        'cat-events',
        'Cultural Night rehearsal schedule',
        'Has the rehearsal order been shared with club representatives? We need to arrange practice room timing.',
      ],
      [
        'cat-programming',
        'Flutter responsive layout question',
        'What is the best way to avoid RenderFlex overflow in compact dashboard cards? Expanded or FittedBox?',
      ],
      [
        'cat-clubs',
        'Debating club new member orientation',
        'Is the orientation beginner friendly? I have never participated in formal debate before.',
      ],
    ];
    return rows.asMap().entries.map((entry) {
      final author =
          'u-stu-${((entry.key % 12) + 1).toString().padLeft(3, '0')}';
      return DemoForumPost(
        id: 'post-${(entry.key + 1).toString().padLeft(3, '0')}',
        categoryId: entry.value[0],
        authorId: author,
        title: entry.value[1],
        body: entry.value[2],
        createdAt: DateTime(
          2026,
          7,
          24,
        ).subtract(Duration(hours: entry.key * 3 + 1)),
        reactions: 2 + (entry.key * 5) % 18,
      );
    }).toList();
  }

  static List<DemoForumComment> _forumComments(List<DemoForumPost> posts) {
    final commentBank = [
      'I checked with the class representative and they said the teacher will post the official update tonight.',
      'I have a clean scan of my notes. I can upload the important pages after evening class.',
      'For this problem, start by listing the candidate key before trying to split the relation.',
      'The department office usually accepts group requests faster when the CR submits one written application.',
      'I faced the same issue yesterday and clearing the app cache refreshed the registration status.',
      'Our teacher said either approach is accepted if the explanation and edge cases are correct.',
      'The portal notice is the official one, but it is better to keep a screenshot of the confirmation.',
      'I am interested. I am stronger in implementation than math-heavy problems, so a balanced team would help.',
      'The library second floor was quiet after 3 PM this week, especially near the newspaper section.',
      'Please avoid last-minute submission. The upload queue becomes slow near deadline time.',
      'I asked the lab assistant; they are checking the router near CSE Lab 2 tomorrow morning.',
      'A portfolio project is strong if it has authentication, role-based flows, and clear documentation.',
    ];
    final comments = <DemoForumComment>[];
    var counter = 1;
    for (final post in posts) {
      for (var index = 0; index < 3; index++) {
        comments.add(
          DemoForumComment(
            id: 'comment-${counter.toString().padLeft(3, '0')}',
            postId: post.id,
            authorId:
                'u-stu-${(((counter + index) % 12) + 1).toString().padLeft(3, '0')}',
            body: commentBank[(counter + index) % commentBank.length],
            createdAt: post.createdAt.add(Duration(minutes: 22 + index * 31)),
            parentId: index == 2
                ? 'comment-${(counter - 1).toString().padLeft(3, '0')}'
                : null,
          ),
        );
        counter++;
      }
    }
    return comments;
  }

  static List<DemoForumReport> _forumReports(List<DemoForumPost> posts) {
    return [
      DemoForumReport(
        id: 'report-001',
        postId: posts[8].id,
        reporterId: 'u-stu-001',
        reason: 'Possible answer sharing before official discussion time',
        status: 'pending',
        createdAt: DateTime(2026, 7, 24, 19, 10),
      ),
      DemoForumReport(
        id: 'report-002',
        postId: posts[17].id,
        reporterId: 'u-stu-004',
        reason:
            'Wi-Fi complaint contains a room number but no support ticket context',
        status: 'pending',
        createdAt: DateTime(2026, 7, 24, 20, 4),
      ),
      DemoForumReport(
        id: 'report-003',
        postId: posts[3].id,
        reporterId: 'u-stu-007',
        reason: 'Duplicate question already answered in campus life category',
        status: 'resolved',
        createdAt: DateTime(2026, 7, 23, 17, 30),
      ),
    ];
  }

  static List<DemoSupportTicket> _supportTickets() {
    return [
      DemoSupportTicket(
        id: 'ticket-001',
        requesterId: 'u-stu-001',
        subject: 'Payment receipt not visible after partial payment',
        category: 'Finance',
        priority: 'High',
        status: 'open',
        createdAt: DateTime(2026, 7, 23, 13, 10),
        description:
            'Receipt tile is missing after a partial payment against Spring 2026 invoice.',
        assignedOfficeId: 'office-accounts',
        userRole: 'Student',
        lastUpdated: DateTime(2026, 7, 23, 16, 40),
      ),
      DemoSupportTicket(
        id: 'ticket-002',
        requesterId: 'u-stu-002',
        subject: 'Course add request for CSE 425 section 5B',
        category: 'Academic',
        priority: 'Medium',
        status: 'pending',
        createdAt: DateTime(2026, 7, 22, 15, 45),
        description:
            'Student wants to add a section after checking routine conflicts.',
        assignedOfficeId: 'office-program',
        userRole: 'Student',
        lastUpdated: DateTime(2026, 7, 22, 16, 5),
      ),
      DemoSupportTicket(
        id: 'ticket-003',
        requesterId: 'u-stu-004',
        subject: 'ID card replacement request',
        category: 'Student Affairs',
        priority: 'Low',
        status: 'closed',
        createdAt: DateTime(2026, 7, 20, 11, 15),
        description: 'Replacement ID card request with lost-card note.',
        assignedOfficeId: 'office-admission',
        userRole: 'Student',
        lastUpdated: DateTime(2026, 7, 21, 9, 45),
        resolution: 'Replacement request approved for collection.',
      ),
      DemoSupportTicket(
        id: 'ticket-004',
        requesterId: 'u-stu-006',
        subject: 'Scholarship transcript upload clarification',
        category: 'Scholarship',
        priority: 'Medium',
        status: 'open',
        createdAt: DateTime(2026, 7, 24, 10, 5),
        description:
            'Student asks whether portal result sheet can support a scholarship application.',
        assignedOfficeId: 'office-registrar',
        userRole: 'Student',
        lastUpdated: DateTime(2026, 7, 24, 10, 8),
      ),
      DemoSupportTicket(
        id: 'ticket-005',
        requesterId: 'u-stu-010',
        subject: 'Campus Wi-Fi unstable near library',
        category: 'IT Support',
        priority: 'Medium',
        status: 'pending',
        createdAt: DateTime(2026, 7, 24, 12, 30),
        description: 'Campus Wi-Fi drops near library second floor.',
        assignedOfficeId: 'office-ict',
        userRole: 'Student',
        lastUpdated: DateTime(2026, 7, 24, 12, 34),
      ),
      DemoSupportTicket(
        id: 'ticket-006',
        requesterId: 'u-stu-013',
        subject: 'Transport route pickup location update',
        category: 'Transport',
        priority: 'Low',
        status: 'open',
        createdAt: DateTime(2026, 7, 21, 9, 20),
        description: 'Pickup location needs update for Mirpur route.',
        assignedOfficeId: 'office-admission',
        userRole: 'Student',
        lastUpdated: DateTime(2026, 7, 21, 9, 20),
      ),
    ];
  }

  static List<DemoSupportMessage> _supportMessages() {
    return [
      DemoSupportMessage(
        id: 'msg-001',
        ticketId: 'ticket-001',
        authorId: 'u-stu-001',
        message:
            'I paid 10,000 BDT through the demo counter but the receipt tile is not appearing under payment history.',
        createdAt: DateTime(2026, 7, 23, 13, 12),
      ),
      DemoSupportMessage(
        id: 'msg-002',
        ticketId: 'ticket-001',
        authorId: 'u-admstaff-001',
        message:
            'Finance office is reviewing the ledger. Please keep the transaction slip until the receipt is updated.',
        createdAt: DateTime(2026, 7, 23, 16, 40),
      ),
      DemoSupportMessage(
        id: 'msg-003',
        ticketId: 'ticket-002',
        authorId: 'u-stu-002',
        message:
            'I want to add CSE 425 because it does not conflict with my current routine.',
        createdAt: DateTime(2026, 7, 22, 15, 48),
      ),
      DemoSupportMessage(
        id: 'msg-004',
        ticketId: 'ticket-004',
        authorId: 'u-stu-006',
        message:
            'Can I submit the downloaded result sheet while the official transcript is pending?',
        createdAt: DateTime(2026, 7, 24, 10, 8),
      ),
      DemoSupportMessage(
        id: 'msg-005',
        ticketId: 'ticket-005',
        authorId: 'u-stu-010',
        message:
            'The Wi-Fi disconnects every few minutes near the library second floor.',
        createdAt: DateTime(2026, 7, 24, 12, 34),
      ),
    ];
  }

  static List<DemoInvoice> _invoices() {
    return List.generate(180, (offset) {
      final studentNo = offset + 1;
      final studentId = 'u-stu-${studentNo.toString().padLeft(3, '0')}';
      final creditFee = 39000 + (offset % 8) * 2500;
      final labFee = offset % 3 == 0
          ? 3500
          : offset % 3 == 1
          ? 2500
          : 0;
      final examFee = 2200 + (offset % 4) * 300;
      final previousDue = offset % 11 == 0 ? 3500 : 0;
      final waiver = offset % 9 == 0
          ? 9000
          : offset % 5 == 0
          ? 5500
          : 0;
      final subtotal = 8000 + creditFee + labFee + examFee + 1500 + previousDue;
      final total = subtotal - waiver;
      final paid = offset % 13 == 0
          ? total
          : offset % 4 == 0
          ? (total * 0.72).round()
          : offset % 3 == 0
          ? (total * 0.55).round()
          : (total * 0.38).round();
      return DemoInvoice(
        id: 'inv-${studentNo.toString().padLeft(3, '0')}',
        studentId: studentId,
        semester: offset % 3 == 0
            ? 'Spring 2026'
            : offset % 3 == 1
            ? 'Summer 2026'
            : 'Fall 2025',
        items: {
          'Registration fee': 8000,
          'Tuition / credit fee': creditFee,
          'Lab fee': labFee,
          'Exam fee': examFee,
          'Library and other fees': 1500,
          if (previousDue > 0) 'Previous due': previousDue,
        },
        waiver: waiver,
        paid: paid,
        dueDate: DateTime(2026, offset % 3 == 2 ? 7 : 8, 5 + offset % 20),
      );
    });
  }

  static List<DemoPayment> _payments(List<DemoInvoice> invoices) {
    final payments = <DemoPayment>[];
    var counter = 1;
    for (final invoice in invoices) {
      if (invoice.paid <= 0) {
        continue;
      }
      final firstAmount = invoice.paid > 30000
          ? (invoice.paid * 0.6).round()
          : invoice.paid;
      final secondAmount = invoice.paid - firstAmount;
      final rows = secondAmount > 0
          ? [firstAmount, secondAmount]
          : [firstAmount];
      for (final amount in rows) {
        final day = counter == 1 ? 26 : 1 + counter % 25;
        payments.add(
          DemoPayment(
            id: 'pay-${counter.toString().padLeft(3, '0')}',
            invoiceId: invoice.id,
            studentId: invoice.studentId,
            amount: amount,
            method: counter % 3 == 0
                ? 'Card counter'
                : counter % 3 == 1
                ? 'Bank deposit'
                : 'Mobile banking counter',
            paidAt: DateTime(2026, 7, day),
            receiptNo:
                'EUB-RCPT-2607${day.toString().padLeft(2, '0')}-${counter.toString().padLeft(3, '0')}',
            status: counter % 17 == 0 ? 'Pending Verification' : 'Verified',
            reference: 'INV-${invoice.id.toUpperCase()}',
          ),
        );
        counter++;
      }
    }
    return payments;
  }

  static List<DemoResult> _results() {
    return [
      DemoResult(
        id: 'res-001',
        studentId: 'u-stu-001',
        courseId: 'course-cse231',
        semester: 'Fall 2025',
        marks: 84,
        letterGrade: 'A+',
        gradePoint: 4.00,
      ),
      DemoResult(
        id: 'res-002',
        studentId: 'u-stu-001',
        courseId: 'course-mat205',
        semester: 'Fall 2025',
        marks: 78,
        letterGrade: 'A',
        gradePoint: 3.75,
      ),
      DemoResult(
        id: 'res-003',
        studentId: 'u-stu-001',
        courseId: 'course-eng205',
        semester: 'Fall 2025',
        marks: 73,
        letterGrade: 'A-',
        gradePoint: 3.50,
      ),
      DemoResult(
        id: 'res-004',
        studentId: 'u-stu-001',
        courseId: 'course-cse315',
        semester: 'Spring 2026',
        marks: 81,
        letterGrade: 'A+',
        gradePoint: 4.00,
      ),
      DemoResult(
        id: 'res-005',
        studentId: 'u-stu-001',
        courseId: 'course-cse331',
        semester: 'Spring 2026',
        marks: 76,
        letterGrade: 'A',
        gradePoint: 3.75,
      ),
      DemoResult(
        id: 'res-006',
        studentId: 'u-stu-002',
        courseId: 'course-cse315',
        semester: 'Spring 2026',
        marks: 72,
        letterGrade: 'A-',
        gradePoint: 3.50,
      ),
      DemoResult(
        id: 'res-007',
        studentId: 'u-stu-004',
        courseId: 'course-cse315',
        semester: 'Spring 2026',
        marks: 88,
        letterGrade: 'A+',
        gradePoint: 4.00,
      ),
      ...List.generate(420, (offset) {
        final studentNo = offset % 140 + 1;
        final courseIds = [
          'course-cse231',
          'course-cse315',
          'course-cse331',
          'course-cse341',
          'course-eee201',
          'course-bus201',
          'course-eng205',
          'course-ce211',
          'course-mat205',
          'course-sta301',
        ];
        final marks = 62 + (offset * 7) % 31;
        final grade = marks >= 80
            ? ('A+', 4.00)
            : marks >= 75
            ? ('A', 3.75)
            : marks >= 70
            ? ('A-', 3.50)
            : marks >= 65
            ? ('B+', 3.25)
            : ('B', 3.00);
        return DemoResult(
          id: 'res-${(offset + 8).toString().padLeft(3, '0')}',
          studentId: 'u-stu-${studentNo.toString().padLeft(3, '0')}',
          courseId: courseIds[offset % courseIds.length],
          semester: offset % 2 == 0 ? 'Fall 2025' : 'Spring 2026',
          marks: marks,
          letterGrade: grade.$1,
          gradePoint: grade.$2,
        );
      }),
    ];
  }

  static List<DemoScholarship> _scholarships() {
    return [
      DemoScholarship(
        id: 'scholar-001',
        title: 'Merit Scholarship for Spring 2026',
        description:
            'Waiver for students with CGPA 3.75 or higher and strong attendance.',
        deadline: DateTime(2026, 8, 15),
        eligibility: 'CGPA 3.75+, no disciplinary record',
        status: 'open',
      ),
      DemoScholarship(
        id: 'scholar-002',
        title: 'Need Based Tuition Support',
        description:
            'Financial assistance for students with verified family income documents.',
        deadline: DateTime(2026, 8, 20),
        eligibility: 'Income certificate and advisor recommendation',
        status: 'open',
      ),
      DemoScholarship(
        id: 'scholar-003',
        title: 'Programming Contest Excellence Award',
        description:
            'One-time waiver for students representing EUB in programming contests.',
        deadline: DateTime(2026, 9, 5),
        eligibility: 'Contest participation proof',
        status: 'open',
      ),
      DemoScholarship(
        id: 'scholar-004',
        title: 'Female in Engineering Grant',
        description:
            'Department-supported grant for female engineering students.',
        deadline: DateTime(2026, 9, 10),
        eligibility: 'Engineering student with CGPA 3.50+',
        status: 'open',
      ),
      DemoScholarship(
        id: 'scholar-005',
        title: 'Sibling Waiver Application',
        description: 'Partial waiver for currently enrolled siblings.',
        deadline: DateTime(2026, 8, 30),
        eligibility: 'Both siblings must be active students',
        status: 'open',
      ),
    ];
  }

  static List<DemoNotification> _notifications() {
    return [
      DemoNotification(
        id: 'noti-001',
        userId: 'u-stu-001',
        title: 'DBMS assignment graded',
        body: 'Your Database Normalization Assignment has been graded.',
        createdAt: DateTime(2026, 7, 24, 21, 10),
      ),
      DemoNotification(
        id: 'noti-002',
        userId: 'u-stu-001',
        title: 'Upcoming quiz',
        body: 'DBMS Normalization Quiz is open until August 2.',
        createdAt: DateTime(2026, 7, 24, 9, 0),
      ),
      DemoNotification(
        id: 'noti-003',
        userId: 'u-stu-001',
        title: 'Event registration confirmed',
        body: 'You are registered for EUB Programming Contest.',
        createdAt: DateTime(2026, 7, 22, 14, 20),
        read: true,
      ),
      DemoNotification(
        id: 'noti-004',
        userId: 'u-tea-001',
        title: 'New submission received',
        body: 'Nayem Ahmed submitted Software Requirements Document.',
        createdAt: DateTime(2026, 7, 24, 21, 6),
      ),
      DemoNotification(
        id: 'noti-005',
        userId: 'u-adm-001',
        title: 'Forum reports pending',
        body: 'Two discussion reports require moderation review.',
        createdAt: DateTime(2026, 7, 24, 20, 10),
      ),
    ];
  }

  static List<DemoApproval> _approvals() {
    return [
      DemoApproval(
        id: 'apv-001',
        type: 'Event approval',
        title: 'Cybersecurity Awareness Session venue confirmation',
        requesterId: 'u-tea-001',
        status: 'pending',
        createdAt: DateTime(2026, 7, 22),
      ),
      DemoApproval(
        id: 'apv-002',
        type: 'Club request',
        title: 'Photography Club waiting-list expansion',
        requesterId: 'u-stu-010',
        status: 'pending',
        createdAt: DateTime(2026, 7, 23),
      ),
      DemoApproval(
        id: 'apv-003',
        type: 'Scholarship request',
        title: 'Need Based Tuition Support for Lamia Sultana',
        requesterId: 'u-stu-012',
        status: 'pending',
        createdAt: DateTime(2026, 7, 24),
      ),
      DemoApproval(
        id: 'apv-004',
        type: 'Role request',
        title: 'Assign forum moderator access to Administration officer',
        requesterId: 'u-admstaff-001',
        status: 'pending',
        createdAt: DateTime(2026, 7, 24),
      ),
      DemoApproval(
        id: 'apv-005',
        type: 'Content review',
        title: 'Review reported SQL answer discussion',
        requesterId: 'u-stu-001',
        status: 'pending',
        createdAt: DateTime(2026, 7, 24),
      ),
      DemoApproval(
        id: 'apv-006',
        type: 'Routine publish',
        title: 'Publish revised CSE 6A Wednesday lab slot',
        requesterId: 'u-tea-001',
        status: 'approved',
        createdAt: DateTime(2026, 7, 20),
      ),
      DemoApproval(
        id: 'apv-007',
        type: 'Payment review',
        title: 'Verify partial payment receipt for Nayem Ahmed',
        requesterId: 'u-stu-001',
        status: 'pending',
        createdAt: DateTime(2026, 7, 23),
      ),
    ];
  }

  static List<DemoActivity> _activities() {
    final entries = [
      [
        'u-tea-001',
        'Teacher created assignment',
        'Dr. Farhan published Database Normalization Assignment for CSE 315 6A.',
      ],
      [
        'u-stu-001',
        'Student submitted assignment',
        'Nayem Ahmed submitted DBMS normalization work.',
      ],
      [
        'u-tea-001',
        'Teacher graded assignment',
        'Dr. Farhan graded Nayem Ahmed with feedback.',
      ],
      [
        'u-admstaff-001',
        'Administration updated routine',
        'Administration officer revised CSE 6A lab timing.',
      ],
      [
        'u-adm-001',
        'Admin approved event',
        'Cybersecurity Awareness Session moved to pending venue confirmation.',
      ],
      [
        'u-stu-004',
        'Student joined event',
        'Tasnim Akter registered for Robotics Workshop.',
      ],
      [
        'u-stu-001',
        'Forum report created',
        'Nayem reported an SQL answer discussion for moderation.',
      ],
      [
        'u-admstaff-001',
        'Support reply sent',
        'Administration replied to a payment receipt support ticket.',
      ],
      [
        'u-tea-005',
        'Attendance saved',
        'Operating Systems attendance was marked for CSE 6A.',
      ],
      [
        'u-stu-010',
        'Ticket created',
        'Farzana reported unstable Wi-Fi near library.',
      ],
    ];
    final activities = <DemoActivity>[];
    for (var index = 0; index < 40; index++) {
      final row = entries[index % entries.length];
      activities.add(
        DemoActivity(
          id: 'act-${(index + 1).toString().padLeft(3, '0')}',
          actorId: row[0],
          title: row[1],
          detail: row[2],
          createdAt: DateTime(2026, 7, 24).subtract(Duration(hours: index * 2)),
        ),
      );
    }
    return activities;
  }
}
