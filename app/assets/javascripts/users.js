function getUsersList(user_type){
  $.ajax({
      type: "GET",
      async: true,
      url: "/users",
      data: {"user_type": user_type},
      dataType: "script"
  });
}
