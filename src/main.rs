use actix_web::{middleware, App, Error, HttpRequest, HttpResponse, HttpServer};
use std::io;

#[actix_web::get("/")]
async fn index(req: HttpRequest) -> Result<HttpResponse, Error> {
    println!("{:?}", req);
    Ok(HttpResponse::Ok()
        .content_type("text/plain")
        .body("Welcome!"))
}

async fn async_main() -> io::Result<()> {
    std::env::set_var("RUST_LOG", "actix_web=debug");
    env_logger::init();

    println!("Started http server: 127.0.0.1:8443");

    HttpServer::new(|| {
        App::new()
            // enable logger
            .wrap(middleware::Logger::default())
            .service(index)
    })
    .bind("127.0.0.1:8443")?
    .run()
    .await
}

fn main() {
    actix_web::rt::System::new("")
        .block_on(async { async_main().await })
        .unwrap_or_else(|e| eprintln!("Got error: {} while running main.", e));
}
