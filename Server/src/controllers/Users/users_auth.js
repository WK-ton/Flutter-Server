const con = require("../../config/Database");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

exports.getItem = (req,res) => {
  res.send("Hello world");
};

exports.userLogin = (req, res) => {
  const email = req.body.email;
  const password = req.body.password;

  if (!email || !password) {
    return res.send(
      JSON.stringify({
        success: false,
        message: "Email and password are required",
      })
    );
  }
  const getUser = "SELECT * FROM User WHERE email = ?";
  con.query(getUser, [email], function (error, results) {
    if (error) {
      return res.send(JSON.stringify({ success: false, message: error }));
    }
    if (results.length === 0) {
      return res.send(
        JSON.stringify({ success: false, message: "Email not found" })
      );
    }
    const user = results[0];

    bcrypt.compare(password, user.password, function (error, passwordMatch) {
      if (error) {
        return res.send(JSON.stringify({ success: false, message: error }));
      }

      if (!passwordMatch) {
        return res.send(
          JSON.stringify({ success: false, message: "Password not found" })
        );
      }
      const token = jwt.sign({ userId: user.id, name: user.name, email: user.email, phone: user.phone, image: user.image }, "secret-key", {
        expiresIn: "10h",
      });

      res.send(
        JSON.stringify({ success: true, message: "Login successful", token, userId: user.id, name: user.name, email: user.email, phone: user.phone })
      );
    });
  });
};


exports.signUp = (req, res) => {
  const name = req.body.name;
  const email = req.body.email;
  const password = req.body.password;
  const password_repeat = req.body.password_repeat;
  const phone = req.body.phone;
  const image = "image_1694531065362.jpg";

  const nameRegex = /^[A-Za-z\s]+$/;
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  const phoneRegex = /^\d{10}$/;

  if (!name || !name.match(nameRegex)) {
    return res.send(
      JSON.stringify({ success: false, message: "กรุณาใส่ชื่อให้ถูกต้อง" })
    );
  }
  if (!email || !email.match(emailRegex)) {
    return res.send(
      JSON.stringify({ success: false, message: "กรุณาใส่อีเมลให้ถูกต้อง" })
    );
  }
  if (password !== password_repeat) {
    return res.send(
      JSON.stringify({ success: false, message: "รหัสผ่านของคุณไม่ตรงกัน" })
    );
  }
  if (!phone || !phone.match(phoneRegex)) {
    return res.send(
      JSON.stringify({
        success: false,
        message: "หมายเลขโทรศัพท์ของคุณไม่ถูกต้อง",
      })
    );
  }

  const checkDuplicate =
    "SELECT * FROM User WHERE name = ? OR email = ? OR phone = ?";
  con.query(checkDuplicate, [name, email, phone], function (error, results) {
    if (error) {
      return res.send(JSON.stringify({ success: false, message: error }));
    }
    if (results.length > 0) {
      
      const duplicateFields = results.reduce((fields, row) => {
       
        if (row.name === name) {
          fields.name = true;
        }
        if (row.email === email) {
          fields.email = true;
        }
        if (row.phone === phone) {
          fields.phone = true;
        }
        return fields;
      }, {});
      
      const duplicateFieldsMessage = Object.keys(duplicateFields).join(",");

      return res.send(
        JSON.stringify({
          success: false,
          message: `ข้อมูลมีผู้ใช้งานแล้ว: ${duplicateFieldsMessage}`,
        })
      );
    }
    const sql =
      "INSERT INTO User(name, email, password, password_repeat, phone, image) VALUES (?,?,?,?,?,?)";
    bcrypt.hash(password, 8, function (error, hashPassword) {
      if (error) {
        res.send(JSON.stringify({ success: false, message: error }));
      } else {
        con.query(
          sql,
          [name, email, hashPassword, hashPassword, phone, image],
          function (error, data, fields) {
            if (error) {
              res.send(JSON.stringify({ success: false, message: error }));
            } else {
              res.send(JSON.stringify({ success: true, message: "register" }));
            }
          }
        );
      }
    });
  });
};




exports.getUsers = (req, res) => {
  const value = [ 
    req.params.id,
    req.body.name,
    req.body.email,
    req.body.phone,
  ]
  const sql = "SELECT `id`,`name`,`email`,`phone` FROM User";
  con.query(sql, [value], (err, result) => {
    if (err) {
      return res.json({ status: "Error", message: "Failed to retrieve user data" });
    }

    if (result.length === 0) {
      return res.json({ status: "Error", message: "User not found" });
    }
    return res.json({ status: "Success", result });
  });
};

exports.deleteUser = (req, res) => {
  const id = req.params.id;
  const sql = "DELETE FROM User WHERE id = ?";
  con.query(sql, [id], (err, result) => {
      if (err) return res.json({ Error: "Delete User Error in sql" });
      return res.json({ Status: "Success" });
  });
};


exports.updateUserName = (req, res) => {
  const id = req.params.id;
  const newName = req.body.name;

  const checkDuplicateSql = "SELECT COUNT(*) AS count FROM User WHERE name = ?";
  con.query(checkDuplicateSql, [newName], (checkErr, checkResult) => {
    if (checkErr) {
      return res.json({ Error: "Error in SQL query for checking duplicate name" });
    }
    if (checkResult[0].count > 0) {
      return res.status(409).json({ Error: "Duplicate name found", message: "ชื่อผู้ใช้นี้มีอยู่ในระบบแล้ว" });
    } else {
      const updateSql = "UPDATE User SET name = ? WHERE id = ?";
      con.query(updateSql, [newName, id], (updateErr, updateResult) => {
        if (updateErr) {
          return res.json({ Error: "Update User Error in SQL" });
        }
        return res.json({ Status: "Success" });
      });
    }
  });
};

exports.updateUserImage = (req, res) => {
  const id = req.params.id;
  const image = req.file ? req.file.filename : null;

  const updateSql = "UPDATE User SET image = ? WHERE id = ?";
  con.query(updateSql, [image, id], (updateErr, updateResult) => {
    if (updateErr) {
      return res.json({ Error: "Update User Image Error in SQL" });
    }
    return res.json({ Status: "Success" });
  });
};



exports.insertImage = (req, res) => {
  const sql = "INSERT INTO User (image) VALUES (?)";
  const values = [
    req.file.filename,
  ];
  con.query(sql,[values], (err, result) => {
    if (err) {
      return res.json({ Error: 'Error creating car' });
    }
    return res.json({ Status: 'Success' });
  });
};

exports.getName = (req, res) => {
  const id = req.params.id; 

  const sql = "SELECT `name` FROM User WHERE id = ?"; 

  con.query(sql, [id], (err, result) => {
    if (err) {
      return res.json({ status: "Error", message: "Failed to retrieve user data" });
    }

    if (result.length === 0) {
      return res.json({ status: "Error", message: "User not found" });
    }

    const userName = result[0].name; 

    return res.json({ status: "Success", name: userName });
  });
};


