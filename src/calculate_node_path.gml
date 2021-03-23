#define calculate_node_path
//calculate_node_path(start_x,start_y,target_x,target_y,flee)

//round out coordinates
start_x = round(argument0 / grid_res) * grid_res
start_y = round(argument1 / grid_res) * grid_res
target_x =  round(argument2 / grid_res) * grid_res
target_y =  round(argument3 / grid_res) * grid_res
flee = argument4

//initialize node data
ds_grid_clear(grid_checked,0) //0 - unchecked, 1 - checked
ds_grid_clear(grid_closed,0) //0 - open, 1 - closed
ds_grid_clear(grid_direction,0)
ds_grid_clear(grid_fcost,0)
ds_list_clear(list_fcost)

check_x = start_x
check_y = start_y
fcost_highest = 0

var loop_max,loop_counter;
found_path = false
loop_max = -1
loop_counter = 0

while !found_path {
    //check adjacent nodes
    check_node(-grid_res,0)
    check_node(+grid_res,0)
    check_node(0,-grid_res)
    check_node(0,+grid_res)
    if 1 {
        //diagonal check
        check_node(-grid_res,-grid_res)
        check_node(+grid_res,-grid_res)
        check_node(-grid_res,+grid_res)
        check_node(+grid_res,+grid_res)
    }
    //abandon pathfinding process if no more nodes left
    if ds_list_empty(list_fcost) {
        break
    }
    
    var fcost;
    if flee {
        //determine highest fcost
        ds_list_sort(list_fcost,false)
        fcost = ds_list_find_value(list_fcost,0)
        if fcost < fcost_highest {
            goal_x = ds_grid_value_x(grid_fcost,0,0,grid_w,grid_h,fcost) * grid_res
            goal_y = ds_grid_value_y(grid_fcost,0,0,grid_w,grid_h,fcost) * grid_res
            found_path = true
        }
        
        fcost_highest = fcost
    } else {
        //determine lowest fcost
        ds_list_sort(list_fcost,true)
        fcost = ds_list_find_value(list_fcost,0)
    }
    
    //mark node as closed
    var grid_x,grid_y;
    grid_x = ds_grid_value_x(grid_fcost,0,0,grid_w,grid_h,fcost)
    grid_y = ds_grid_value_y(grid_fcost,0,0,grid_w,grid_h,fcost)
    ds_grid_set(grid_closed,grid_x,grid_y,1)
    //remove closed node fcost data
    ds_grid_set(grid_fcost,grid_x,grid_y,0)
    ds_list_delete(list_fcost,0)
    
    //set node for next check
    check_x = grid_x * grid_res
    check_y = grid_y * grid_res
    
    //DEBUG
    loop_counter += 1
    if loop_max != -1 {
        if loop_counter >= loop_max
        break
    }
}
return found_path

