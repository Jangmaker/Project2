<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="index.css">
    <title>로그인 및 회원가입</title>
</head>
<body>
    <div class="login-container">
        <h2>로그인</h2>
        <form id="loginForm" action="https://yas24.store" method="post" onsubmit="return handleSubmit(event)">
            <label for="username">아이디</label>
            <input type="text" id="username" name="id" placeholder="아이디" required>
            <label for="password">비밀번호</label>
            <input type="password" id="password" name="pw" placeholder="비밀번호" required>
            <input type="hidden" name="action" value="login">
            <button type="submit">로그인</button>
            <button type="button" onclick="window.location.href = './signup.jsp'">회원가입</button>
        </form>
    </div>

    <div id="loginCompleteMessage" class="message" style="display: none;"></div>

    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String id = request.getParameter("id");
            String pw = request.getParameter("pw");
            String dbUrl = "jdbc:mariadb://yas-db.cfcs4qqamqkc.ap-northeast-2.rds.amazonaws.com:3306/cafe"; // 수정된 RDS 엔드포인트
            String dbUser = "admin";
            String dbPassword = "Dlwogur10!";
            String userName = null;

            try {
                Class.forName("org.mariadb.jdbc.Driver"); // MariaDB JDBC 드라이버
                Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                String sql = "SELECT id FROM users WHERE id = ? AND pw = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, id);
                pstmt.setString(2, pw);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    userName = rs.getString("id");
                }
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }

            if (userName != null) {
                out.println("<script>");
                out.println("document.getElementById('loginCompleteMessage').innerHTML = '" + userName + "님 환영합니다!';");
                out.println("document.getElementById('loginCompleteMessage').style.display = 'block';");
                out.println("setTimeout(() => { window.location.href = './order.jsp?id=" + userName + "'; }, 2000);");
                out.println("</script>");
            } else {
                out.println("<script>alert('아이디 또는 비밀번호가 올바르지 않습니다.');</script>");
            }
        }
    %>

    <script>
        // Enter 키를 눌렀을 때 로그인 함수 호출
        document.addEventListener('keypress', function(event) {
            if (event.key === 'Enter') {
                document.getElementById('loginForm').submit();
            }
        });
    </script>
</body>
</html>
