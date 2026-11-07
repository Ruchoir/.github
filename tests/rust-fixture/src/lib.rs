//! Run by the CI of this repository through `rust.yml`, once without stores and once with both, to
//! check that the workflow starts what it is asked for, and only that.

#[cfg(test)]
mod tests {
    use std::net::TcpStream;
    use std::time::Duration;

    fn var(name: &str) -> String {
        std::env::var(name).unwrap_or_default()
    }

    fn answers(address: &str) -> bool {
        let address = address.parse().expect("a socket address");
        TcpStream::connect_timeout(&address, Duration::from_secs(5)).is_ok()
    }

    #[test]
    fn the_stores_are_the_ones_asked_for() {
        let database = var("RUCHOIR_TEST_DATABASE_URL");
        let valkey = var("RUCHOIR_TEST_VALKEY_URL");
        if var("RUCHOIR_TEST_STORES") == "required" {
            assert_eq!(
                database,
                "postgres://ruchoir:ruchoir@localhost:5432/ruchoir_test"
            );
            assert_eq!(valkey, "redis://localhost:6379");
            assert!(answers("127.0.0.1:5432"), "PostgreSQL does not answer");
            assert!(answers("127.0.0.1:6379"), "Valkey does not answer");
        } else {
            assert!(database.is_empty() && valkey.is_empty());
        }
    }
}
