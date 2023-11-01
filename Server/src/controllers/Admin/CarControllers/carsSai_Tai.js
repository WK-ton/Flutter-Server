const con = require ('../../../config/Database');

exports.create_carsSai_Tai = (req, res) => {
    const sql = "INSERT INTO cars_sai_tai (`fromstation`,`tostation`, `number`, `road`, `image`, `time`) VALUES (?)";
    const values = [
      req.body.fromstation,
      req.body.tostation,
      req.body.number,
      req.body.road,
      req.file.filename,
      req.body.time,
    ];
    con.query(sql,[values], (err, result) => {
      if (err) {
        return res.json({ Error: 'Error creating car' });
      }
      return res.json({ Status: 'Success' });
    });
  };

exports.getCars_carsSai_Tai = (req, res) => {
    const sql = "SELECT * FROM cars_sai_tai";
    con.query(sql, (err, result) => {
        if (err) return res.json({ Error: "Get Error in sql" });
        return res.json({ Status: "Success", Result: result });
    });
};
exports.getCarById_carsSai_Tai = (req, res) => {
    const id = req.params.id;
    const sql = "SELECT * FROM cars_sai_tai WHERE id = ?";
    con.query(sql, [id], (err, result) => {
        if (err) return res.json({ Error: "Get cars Error in sql" });
        return res.json({ Status: "Success", Result: result });
    });
};

exports.updateCar_carsSai_Tai = (req, res) => {
    const id = req.params.id;
    const sql = "UPDATE cars_sai_tai SET fromstation = ?, tostation = ?,number = ?, road = ? , time = ? WHERE id = ?";
    con.query(sql, [req.body.fromstation,req.body.tostation, req.body.number, req.body.road, req.body.time, id], (err, result) => {
        if (err) return res.json({ Error: "Update cars Error in sql" });
        return res.json({ Status: "Success" });
    });
};

exports.deleteCar_carsSai_Tai = (req, res) => {
    const id = req.params.id;
    const sql = "DELETE FROM cars_sai_tai WHERE id = ?";
    con.query(sql, [id], (err, result) => {
        if (err) return res.json({ Error: "Delete cars Error in sql" });
        return res.json({ Status: "Success" });
    });
    con.query('ALTER TABLE cars_sai_tai AUTO_INCREMENT = 0', (error, result, fields) => {
        if (error) {
            console.error("Error", error);
        } else {
            console.log({ Status: 'Reset ID Success' });
        }
    });
};