use std::env;
use ril::prelude::*;


fn main() -> ril::Result<()> {
    let args: Vec<String> = env::args().collect();
    let mut text1 = "Operating System (01/09/23 ?.?.??)";
    let mut text2 = "Adventure Mode, No Cheats, Version: 1.18.2";
    let mut classname = "os";
    let mut world_icon="";
    //dbg!(&args);

    if args.len() > 2  {
        text1 = match args[1].as_str() { "" => text1, "-" => text1, t => t };
        text2 = match args[1].as_str() { "" => text2, "-" => text2, t => t };
    }
    if args.len() > 3  { classname = &args[3]; }
    if args.len() > 4  { world_icon= &args[4]; }
    if args.len() > 5  || args.len() <=1 { help(); }

    

    let font:Font = Font::from_bytes(include_bytes!("../assets/MinecraftRegular.otf"), 30.0)?;
    let gray = Rgba::new(128, 128, 128, 255);
    let width = 801;
    let height=96;
    let mut img = Image::new(width, height, Rgba::new(0,0,0,0));

    let text1entity = TextSegment::new(&font, text1, gray).with_position(105, 33);
    let text2entity = TextSegment::new(&font, text2, gray).with_position(105, 61);

    let icon= Image::<Rgba>::open(world_icon);
    match icon {
        Err(_) => println!("No icon path was given"),
        Ok(mut i) => { i.resize(96, 96, ResizeAlgorithm::Nearest); img.paste(0, 0, &i);},
    };
    img.draw(&text1entity);
    img.draw(&text2entity);

    let filepath = format!("./minegrub-world-selection/icons/{}.png", classname);
    match img.save(ImageFormat::Png, &filepath) {
        Err(_) => { img.save(ImageFormat::Png, format!("{}.png", classname))?; println!("Successfully saved to ./{}.png", classname);},
        _ => {println!("Successfully saved to {}", &filepath);},
    }
    
    Ok(())
}



fn help() {
    let helpmsg = r#" Usage: icon-generator <first line> <second line> <class name> [icon filepath]
    > for default text use "-" or an empty string
"#;

    println!("{}", helpmsg);
}
