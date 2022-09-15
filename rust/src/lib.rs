use mlua::prelude::*;

fn hello(lua: &Lua, name: String) -> LuaResult<()> {
    let print: LuaFunction = lua.globals().get("print")?;
    print.call(format!("Hello {name}"))?;
    Ok(())
}

#[mlua::lua_module]
fn rust(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;
    exports.set("hello", lua.create_function(hello)?)?;
    Ok(exports)
}
