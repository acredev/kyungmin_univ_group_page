<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page  import="java.io.PrintWriter"%>
<%@ page  import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="/19831049_finalproject/css/bootstrap.css">
		<link rel="icon" href="/19831049_finalproject/img/favicon.png" type="image/x-icon" sizes="16x16">
		<title>경민대학교 대나무숲 : 익명 게시판</title>
		<style type="text/css">
			a,a:hover{
				color:#000000;
				text-decoration:none;
			}
		</style>
	</head>
	<body>
		<%
		String user_id = null;
		if (session.getAttribute("id") != null)
		{
			user_id = (String)session.getAttribute("id");
		}
		%>
	<nav class="navbar  navbar-default">
			<div class="navbar-header">
				<a class="navbar-brand" href="main.jsp">경민대학교 대나무숲</a>
			</div>
			<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
				<ul class="nav navbar-nav">
					<li><a href="main.jsp">메인</a></li>
					<li class="active"><a href="/19831049_finalproject/jsp/board/anonymous/anonymous_board.jsp">익명 게시판</a></li>
					<li><a href="/19831049_finalproject/jsp/board/tip/tip_board.jsp">Tip 게시판</a></li>
					<li><a href="/19831049_finalproject/jsp/board/data/data_board.jsp">자료실</a></li>
					<li><a href="/19831049_finalproject/jsp/cs/cs.jsp">문의하기</a></li>
					<li><a href="/19831049_finalproject/jsp/etc/about.jsp">프로젝트에 대하여...</a></li>
				</ul>
				<%
				if(user_id == null)
				{%>
					<ul class="nav navbar-nav navbar-right">
						<li><a href="/19831049_finalproject/jsp/member/login/Login.jsp">로그인</a></li>
						<li><a href="/19831049_finalproject/jsp/member/join/join.jsp">회원가입</a></li>
					</ul>
				<%
				}
				else
				{%>
					<ul class="nav navbar-nav navbar-right">
						<li><a href="" onclick="mypage_click()">마이페이지</a></li>
						<li><a href="/19831049_finalproject/jsp/member/login/LogoutAction.jsp">로그아웃</a></li>
					</ul>
				<%		
				}%>
			</div>
		</nav>
		<%
		try
		{
			//JDBC 드라이버 연결
			Class.forName("com.mysql.jdbc.Driver");
			String db_address = "jdbc:mysql://127.0.0.1:3306/19831049_finalproject";
			String db_username = "root";
			String db_pwd = "root";
			Connection connection = DriverManager.getConnection(db_address, db_username, db_pwd);
			
			request.setCharacterEncoding("UTF-8");
			
			String num = request.getParameter("num");
				
			String insertQuery = "SELECT * FROM 19831049_finalproject.board_anonymous WHERE num=" + num;
				
			PreparedStatement psmt = connection.prepareStatement(insertQuery);
			
			ResultSet result = psmt.executeQuery();
			%>
			<div class="container">
				<div class="row">
					<table class="table table-striped" style="text-align:center;border:1px solid #dddddd">
					<%
					while(result.next())
					{%>
						<thead>
							<tr>
								<th colspan="3" style="background-color:#eeeeee; text-align:center;">게시판 글 보기</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td style="width: 20%;">글 제목</td>
								<td colspan="2"><%=result.getString("title") %></td>
							</tr>
							<tr>
								<td>작성자</td>
								<td colspan="2"><%=result.getString("writer") %></td>
							</tr>
							<tr>
								<td>작성 일자</td>
								<td colspan="2"><%=result.getTimestamp("date") %></td>
							</tr>
							<tr>
								<td>내용</td>
								<td colspan="2" style="height: 200px; text-align: left;"><%=result.getString("content") %></td>
							</tr>
						</tbody>
					</table>
					<table class="table table-striped" style="text-align:center;border:1px solid #dddddd">
						<thead>
							<tr>
								<th colspan="3" style="background-color:#eeeeee; text-align:center;">댓글</th>
							</tr>
						</thead>
						<tbody>
						<%
						try
						{
							insertQuery = "SELECT * FROM 19831049_finalproject.comment_anonymous WHERE post_num=" + num;
							
							PreparedStatement psmt_comment = connection.prepareStatement(insertQuery);
							
							ResultSet result_comment = psmt_comment.executeQuery();
							
							while (result_comment.next())
							{%>
								<tr>
									<td>익명<%=result_comment.getString("writer") %></td>
									<td><%=result_comment.getString("content") %></td>
								</tr>
							<%
							}
						}
						catch (Exception ex)
						{
							ex.getMessage();
						}
						%>
							<tr>
								<td colspan="2">
									<form name="comment" action="anonymous_commentAction.jsp" method="post">
										<textarea class="form-control" placeholder="새로운 댓글을 작성해 주세요." name="content" id="content" maxlength="350" style="height:80px;"></textarea>
										<input type="button" class="btn btn-primary pull-right" onclick="comment_click()" value="댓글작성">
										<!-- 글번호 -->
										<input type="hidden" id="post_num" name="post_num" value="<%=result.getString("num") %>">
									</form>
								</td>
							</tr>
						</tbody>
					</table>
					<%} %>
				<a href="/19831049_finalproject/jsp/board/tip/tip_board.jsp" class="btn btn-primary">목록</a>
				</div>
			</div>
			<%
			}
			catch(Exception ex)
			{
				out.print(ex.getMessage());
			}
			%>
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="/19831049_finalproject/js/bootstrap.js"></script>
	<script src="/19831049_finalproject/js/comment.js"></script>
</body>
</html>