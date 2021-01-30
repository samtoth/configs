#![deny(clippy::ll)]

#[macro_use]
extern crate penrose;

use penrose::{
    core::{
        bindings::MouseEvent, config::Config, helpers::index_selectors, manager::WindowManager,
    },
    logging_error_handler,
    xcb::new_xcb_backed_window_manager,
    Backward, Forward, Less, More, Result,
};

use simplelog::{LevelFilter, SimpleLogger};

fn main() -> Result<()> {
    let log_level = LevelFilter::Debug;
    if let Err(e) = SimpleLogger::init(log_level, simplelog::Config::default()) {
        panic!("Logger failed to init! {}", e);
    }

    let config = Config::default()
        .builder()
        .focused_border(0x88c0d0)
        .unfocused_border(0x5e81ac)
        .show_bar(true)
        .build()
        .unwrap_or_else(|s| panic!("Error building config: {}", s));
    let hooks = vec![/*Box::new(dwm_bar(
        XcbDraw::new()?,
        18,
        &TextStyle {
            font: PROFONT.to_string(),
            point_size: 11,
            fg: WHITE.into(),
            bg: Some(BLACK.into()),
            padding: (2.0, 2.0),
        },
        BLUE, // highlight
        GREY, // empty_ws
        config.workspaces().clone(),
    )?)*/];

    let key_bindings = gen_keybindings! {
        "A-j" => run_internal!(cycle_client, Forward);
        "A-k" => run_internal!(cycle_client, Backward);
        "A-S-j" => run_internal!(drag_client, Forward);
        "A-S-k" => run_internal!(drag_client, Backward);
        "A-S-q" => run_internal!(kill_client);
        "A-Tab" => run_internal!(toggle_workspace);
        "A-bracketright" => run_internal!(cycle_screen, Forward);
        "A-bracketleft" => run_internal!(cycle_screen, Backward);
        "A-C-bracketright" => run_internal!(drag_workspace, Forward);
        "A-C-bracketleft" => run_internal!(drag_workspace, Backward);
        "A-grave" => run_internal!(cycle_layout, Forward);
        "A-S-grave" => run_internal!(cycle_layout, Backward);
        "A-S-Up" => run_internal!(update_max_main, More);
        "A-S-Down" => run_internal!(update_max_main, Less);
        "A-S-Right" => run_internal!(update_main_ratio, More);
        "A-S-Left" => run_internal!(update_main_ratio, Less);
        "A-S-Escape" => run_internal!(exit);
        "A-semicolon" => run_external!("rofi -show run");
        "A-Return" => run_external!("kitty");

        refmap [ config.ws_range() ] in {
            "A-{}" => focus_workspace [ index_selectors(config.workspaces().len()) ];
            "A-S-{}" => client_to_workspace [ index_selectors(config.workspaces().len()) ];
        };
    };

    let mouse_bindings = gen_mousebindings! {
        Press Right + [Alt] => |wm: &mut WindowManager<_>, _: &MouseEvent| wm.cycle_workspace(Forward),
        Press Left + [Alt] => |wm: &mut WindowManager<_>, _: &MouseEvent| wm.cycle_workspace(Backward)
    };

    let mut wm = new_xcb_backed_window_manager(config, hooks, logging_error_handler())?;
    wm.grab_keys_and_run(key_bindings, mouse_bindings)?;

    Ok(())
}
