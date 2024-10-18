<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f0f0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-image: url('image/signbg.jpg');
            background-size: cover;
            background-position: center;
        }
        .container {
            background-color: rgba(255, 255, 255, 0.39);
            padding: 35px;
            width: 300px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        .container h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .form-group input {
            width: calc(100% - 12px);
            padding: 8px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 3px;
        }
        .form-group input[type="submit"] {
            background-color: #eec200;
            color: #fff;
            border: none;
            cursor: pointer;
            padding: 10px 20px;
            font-size: 16px;
            border-radius: 3px;
        }
        .form-group input[type="submit"]:hover {
            background-color: #f7eac1;
        }
        .signup-complete {
            display: none;
            text-align: center;
            padding: 20px;
            background-color: #d8d192ef;
            color: white;
            margin-top: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
    </style>
    <script>
        function showMessageAndRedirect() {
            alert('회원가입이 완료되었습니다!');
            window.location.href = '/';
        }

        function redirectToSignup() {
            alert('이미 있는 회원입니다.');
            window.location.href = '/';
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>회원가입</h2>
        <form id="signupForm" method="post">
            <div class="form-group">
                <label for="id">아이디:</label>
                <input type="text" id="id" name="id" required>
            </div>
            <div class="form-group">
                <label for="pw">비밀번호:</label>
                <input type="password" id="pw" name="pw" required>
            </div>
            <div class="form-group">
                <input type="submit" value="회원가입">
            </div>
        </form>
        <div class="signup-complete" id="signupCompleteMessage">
            회원가입이 완료되었습니다!
        </div>
    </div>

    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String id = request.getParameter("id");
            String pw = request.getParameter("pw");

            String url = "jdbc:mariadb://yas-db.cfcs4qqamqkc.ap-northeast-2.rds.amazonaws.com:3306/cafe"; // MariaDB JDBC URL
            String dbUser = "admin";
            String dbPassword = "Dlwogur10!";

            Connection conn = null;
            PreparedStatement pstmt = null;
            PreparedStatement checkStmt = null;

            try {
                Class.forName("org.mariadb.jdbc.Driver"); // MariaDB JDBC 드라이버 클래스
                conn = DriverManager.getConnection(url, dbUser, dbPassword);

                // Check if the user already exists
                String checkSql = "SELECT COUNT(*) FROM users WHERE id = ?";
                checkStmt = conn.prepareStatement(checkSql);
                checkStmt.setString(1, id);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next() && rs.getInt(1) > 0) {
                    out.println("<script>redirectToSignup();</script>");
                } else {
                    String sql = "INSERT INTO users (id, pw) VALUES (?, ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, id);
                    pstmt.setString(2, pw);
                    pstmt.executeUpdate();

                    // Show success message and redirect
                    out.println("<script>showMessageAndRedirect();</script>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<script>alert('회원가입 실패: " + e.getMessage() + "');</script>");
            } finally {
                if (checkStmt != null) try { checkStmt.close(); } catch (SQLException ignore) {}
                if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
            }
        }
    %>
</body>
</html>