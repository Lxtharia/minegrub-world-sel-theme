use std::env;
use ril::prelude::*;


fn main() -> ril::Result<()> {
    let args: Vec<String> = env::args().collect();
    //dbg!(&args);


    // Defaults
    let mut classname = "os";
    let mut text1 = "Operating System (01/09/23 ?.?.??)";
    let mut text2 = "Adventure Mode, No Cheats, Version: 1.18.2";
    let mut distro_icon="";
    let mut output_path = ".";

    // Arguments, very good code, yes yes
    if args.len() > 1  { classname = &args[1]; }
    if args.len() > 2  { text1 = match args[2].as_str() { "" => text1, "-" => text1, t => t }; }
    if args.len() > 3  { text2 = match args[3].as_str() { "" => text2, "-" => text2, t => t }; }
    if args.len() > 4  { distro_icon= match args[4].as_str() { "" => distro_icon, "-" => distro_icon, t => t }; }
    if args.len() > 5  { output_path = &args[5]; }
    if args.len() > 6  || args.len() <=1 { help(); return Ok(()); }

    
    // Create font, color, text and image
    let font:Font = Font::from_bytes(include_bytes!("../assets/MinecraftRegular.otf"), 30.0)?;
    let gray = Rgba::new(128, 128, 128, 255);
    let width = 801;
    let height=96;
    let mut img = Image::new(width, height, Rgba::new(0,0,0,0));

    let text1entity = TextSegment::new(&font, text1, gray).with_position(105, 33);
    let text2entity = TextSegment::new(&font, text2, gray).with_position(105, 61);

    // Drawing
    let icon= Image::<Rgba>::open(distro_icon);
    match icon {
        Err(_) => { println!("No icon found or no path given. Leaving empty."); },
        Ok(mut i) => {
            i.resize(64, 64, ResizeAlgorithm::Bilinear);
            i.resize(96, 96, ResizeAlgorithm::Nearest);
            img.paste(0, 0, &i);
        },
    };
    img.draw(&text1entity);
    img.draw(&text2entity);
    
    // Saving
    let filepath = format!("{}/{}.png", output_path, classname);
    match img.save(ImageFormat::Png, &filepath) {
        Err(e) => { println!("Could not save file\nERROR: {e}"); },
        Ok(_)  => { println!("Successfully saved to {}", &filepath); },
    }
    
    Ok(())
}



fn help() {
    let helpmsg = r#" Usage: icon-generator <first line> <second line> <class name> [icon filepath] [output_dir]
    > for default options use "-" or an empty string
"#;

    println!("\n{}", helpmsg);
}
