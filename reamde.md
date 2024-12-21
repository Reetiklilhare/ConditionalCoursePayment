# ConditionalCoursePayment

## Project Title
ConditionalCoursePayment

## Project Description
The `ConditionalCoursePayment` smart contract is a decentralized platform designed to manage and facilitate conditional payments for online courses on the Ethereum blockchain. It ensures that students pay for courses only after the instructor has marked them as completed, fostering trust and transparency between students and instructors.

## Contract Address
**Deployed Address**: 0x258a10d6b1d4ab0c54bdc3f58b7867d326b8a983

## Project Vision
The vision of the ConditionalCoursePayment platform is to create a trustless and transparent system for online education. By leveraging blockchain technology, the platform eliminates the need for intermediaries, ensuring fair payment for instructors and confidence for students that their funds are securely held until course completion.

## Key Features

### 1. **Course Creation**
Instructors can create courses by specifying the course price, which is stored on the blockchain.

### 2. **Secure Enrollment**
Students can enroll in courses by sending the required payment to the contract. Payments are securely held until the course is marked as completed.

### 3. **Conditional Payment Release**
Funds are released to the instructor only after:
- The instructor marks the course as completed.
- The student confirms the release of the payment.

### 4. **Event Tracking**
All key activities, including course creation, enrollment, course completion, and payment release, are logged through events, ensuring transparency.

### 5. **Access Control**
Strict access control is enforced:
- Only instructors can mark courses as completed.
- Only enrolled students can release payments.

### 6. **Fallback and Withdrawal Mechanisms**
The contract includes mechanisms for handling Ether deposits and withdrawals to manage any excess funds securely.


