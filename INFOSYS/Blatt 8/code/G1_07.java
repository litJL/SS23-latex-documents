import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.Locale;

public class G1_07 {
    public static void main(String args[]) {
        Connection conn = null;
        Configuration conf;

        try {
            conf = Configuration.parse(args);
        } catch( Exception e ) {
            System.out.println("Usage:\n  java GXX_YY path/to/file.txt");
            return;
        }
        var results = new ArrayList<Person>();

        try {
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(
                    "jdbc:postgresql://" + conf.DB_HOST + ":" + conf.DB_PORT + "/" + conf.DB_NAME, conf.DB_USER,
                    conf.DB_PASSWORD);
            DatabaseMetaData dbmd = conn.getMetaData();
            ResultSet salaryView = dbmd.getTables(null, null, "salary" + conf.JAHR, null);
            
            if (!salaryView.next()) {
                Statement stmt = conn.createStatement();
                stmt.executeUpdate("CREATE VIEW Salary" + conf.JAHR
                        + " AS SELECT p.pnr, p.gehalt, CASE WHEN b.betrag = 0 THEN NULL ELSE b.betrag / (SELECT count(*) FROM personal p1 WHERE p.anr = p1.anr) END AS bonus FROM personal p, bonus b WHERE p.anr = b.anr AND b.jahr = "
                        + conf.JAHR);
                stmt.close();
            }
            
            PreparedStatement pstmt = conn
                    .prepareStatement("SELECT s.pnr, p.name, s.gehalt, s.bonus FROM salary" + conf.JAHR + " s, abteilung a, personal p WHERE s.pnr = p.pnr AND p.anr = a.anr AND a.name = ? ORDER BY s.pnr");
            pstmt.setString(1, conf.ABTEILUNG);
            ResultSet res = pstmt.executeQuery();
            while (res.next()) {
                results.add(new Person(res.getInt(1), res.getString(2), res.getDouble(3), res.getDouble(4)));
            }
            pstmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }


        for (var result : results) {
            System.out.println(result);
        }
        try {
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

class Configuration {
    public final String DB_NAME;
    public final String DB_HOST;
    public final String DB_PORT;
    public final String DB_USER;
    public final String DB_PASSWORD;

    public final String JAHR;
    public final String ABTEILUNG;

    private Configuration(String name, String host, String port, String user, String pw, String year, String dept) {
        this.DB_NAME = name;
        this.DB_HOST = host;
        this.DB_PORT = port;
        this.DB_USER = user;
        this.DB_PASSWORD = pw;
        this.JAHR = year;
        this.ABTEILUNG = dept;
    }

    @Override
    public String toString() {
        // Needed for debugging only
        var builder = new StringBuilder();
        builder.append(DB_USER);
        builder.append(':');
        builder.append(DB_PASSWORD);
        builder.append('@');
        builder.append(DB_HOST);
        builder.append(':');
        builder.append(DB_PORT);
        builder.append('/');
        builder.append(DB_NAME);
        builder.append("?year=");
        builder.append(JAHR);
        builder.append("&abteilung=");
        builder.append(ABTEILUNG);
        return builder.toString();
    }

    public static Configuration parse(String args[]) throws IOException {
        if(args.length != 1) {
            throw new IllegalArgumentException();
        }
        var reader = new BufferedReader(new FileReader(args[0]));
        String name = reader.readLine().trim();
        String host = reader.readLine().trim();
        String port = reader.readLine().trim();
        String user = reader.readLine().trim();
        String pw = reader.readLine().trim();
        String year = reader.readLine().trim();
        String dept = reader.readLine().trim();
        return new Configuration(name, host, port, user, pw, year, dept);
    }
}

class Person {
    private final int pnr;
    private final String name;
    private final double gehalt;
	private final double bonus;

    public Person(int pnr, String name, double gehalt, double bonus) {
        this.pnr = pnr;
        this.name = name;
        this.gehalt = gehalt;
		this.bonus = bonus;
    }

    @Override
    public String toString() {
        var builder = new StringBuilder();
        builder.append(pnr);
        builder.append(", ");
        builder.append(name);
        builder.append(": ");
        builder.append(String.format(Locale.ENGLISH, "%.2f", gehalt));
		builder.append(", ");
		builder.append(String.format(Locale.ENGLISH, "%.2f", bonus));
        return builder.toString();
    }
}