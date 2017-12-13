using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JobSearch
{
    class Program
    {
        static void Main(string[] args)
        {
            SqlConnection conn = new SqlConnection("server=.\MTCDB;Database=JobSearch;Integrated Security=true");
            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT CompanyName FROM Companies");
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                Console.WriteLine("{1}", reader.GetString(0), reader.GetString(1));

            }
            reader.Close();
            conn.Close();

            if (Debugger.IsAttached)
            {
                Console.ReadLine();

            }
        }
    }
}
