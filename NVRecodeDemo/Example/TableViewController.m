//
//  TableViewController.m
//  NVRecodeDemo
//
//  Created by Mac on 2018/8/23.
//

#import "TableViewController.h"
#import "MainViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * string = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:string];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"////*****特效合集*****////";
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"摄像头滤镜";
    }else if(indexPath.row == 2){
        cell.textLabel.text = @"抖音_抖动";
    }else if(indexPath.row == 3){
        cell.textLabel.text = @"灵魂出窍";
    }else if(indexPath.row == 4){
        cell.textLabel.text = @"幻觉";
    }else if(indexPath.row == 5){
        cell.textLabel.text = @"五光十色";
    }else if(indexPath.row == 6){
        cell.textLabel.text = @"老旧视频";
    }else if(indexPath.row == 7){
        cell.textLabel.text = @"X光";
    }else if(indexPath.row == 8){
        cell.textLabel.text = @"边缘发光";
    }else if(indexPath.row == 9){
        cell.textLabel.text = @"切片循环";
    }else if(indexPath.row == 10){
        cell.textLabel.text = @"下雪";
    }else if(indexPath.row == 11){
        cell.textLabel.text = @"美颜";
    }else if(indexPath.row == 12){
        cell.textLabel.text = @"哈哈镜";
    }else if(indexPath.row == 13){
        cell.textLabel.text = @"大眼/瘦脸";
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
    }else{
        MainViewController *main = [[MainViewController alloc] initWithIndex:(int)indexPath.row];
        [self presentViewController:main animated:YES completion:nil];
    }
}

@end
