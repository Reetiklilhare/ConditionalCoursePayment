// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ConditionalCoursePayment {
    // Struct to represent a course
    struct Course {
        address instructor; // Address of the instructor
        uint256 price;     // Full price of the course
        bool isCompleted;  // Completion status
        address student;   // Address of the enrolled student
    }

    mapping(uint256 => Course) public courses; // Mapping of course ID to Course struct
    uint256 public courseCount;               // Total number of courses created

    // Events
    event CourseCreated(uint256 indexed courseId, address indexed instructor, uint256 price);
    event CourseEnrolled(uint256 indexed courseId, address indexed student);
    event PaymentReleased(uint256 indexed courseId, address indexed instructor, uint256 amount);
    event CourseCompleted(uint256 indexed courseId);

    // Modifiers
    modifier onlyInstructor(uint256 courseId) {
        require(courses[courseId].instructor == msg.sender, "Caller is not the instructor");
        _;
    }

    modifier onlyStudent(uint256 courseId) {
        require(courses[courseId].student == msg.sender, "Caller is not the student");
        _;
    }

    // Function to create a new course
    function createCourse(uint256 price) external {
        require(price > 0, "Price must be greater than zero");

        unchecked {
            courseCount++;
        }
        courses[courseCount] = Course({
            instructor: msg.sender,
            price: price,
            isCompleted: false,
            student: address(0)
        });

        emit CourseCreated(courseCount, msg.sender, price);
    }

    // Function for a student to enroll in a course
    function enrollInCourse(uint256 courseId) external payable {
        Course storage course = courses[courseId];

        require(course.instructor != address(0), "Course does not exist");
        require(course.student == address(0), "Course is already enrolled");
        require(msg.value == course.price, "Incorrect payment amount");

        course.student = msg.sender;

        emit CourseEnrolled(courseId, msg.sender);
    }

    // Function for the instructor to mark a course as completed
    function markCourseCompleted(uint256 courseId) external onlyInstructor(courseId) {
        Course storage course = courses[courseId];

        require(!course.isCompleted, "Course is already completed");
        require(course.student != address(0), "No student enrolled in the course");

        course.isCompleted = true;

        emit CourseCompleted(courseId);
    }

    // Function for the student to release payment to the instructor
    function releasePayment(uint256 courseId) external onlyStudent(courseId) {
        Course storage course = courses[courseId];

        require(course.isCompleted, "Course is not completed yet");

        uint256 amount = course.price;
        course.price = 0; // Prevent re-entrancy

        (bool success, ) = course.instructor.call{value: amount}("");
        require(success, "Payment transfer failed");

        emit PaymentReleased(courseId, course.instructor, amount);
    }

    // Fallback function to receive Ether
    receive() external payable {}

    // Function to withdraw excess funds from the contract
    function withdrawFunds(uint256 courseId) external onlyInstructor(courseId) {
        Course storage course = courses[courseId];
        uint256 balance = address(this).balance;

        require(balance >= course.price, "Insufficient contract balance");

        (bool success, ) = msg.sender.call{value: course.price}("");
        require(success, "Withdrawal failed");
    }
}
