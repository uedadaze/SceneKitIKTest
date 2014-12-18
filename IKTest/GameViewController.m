//
//  GameViewController.m
//  IKTest
//
//  Created by 市川樹 on 2014/12/18.
//  Copyright (c) 2014年 Itsuki Ichikawa. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // create a new scene
    scene = [SCNScene sceneNamed:@"TestArm.dae"];

    // create and add a camera to the scene
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    [scene.rootNode addChildNode:cameraNode];
    
    // place the camera
    cameraNode.position = SCNVector3Make(0, 0, 30);
    
    // create and add a light to the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 10, 10);
    [scene.rootNode addChildNode:lightNode];
    
    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
    
    //　部位ごとのNodeの作成
    //　モデル全体
    arm = [scene.rootNode childNodeWithName:@"Arm" recursively:YES];
    //　モデルの根っこ
    arm_root = [arm childNodeWithName:@"RootBone" recursively:YES];
    //　モデルの末端
    arm_end = [arm childNodeWithName:@"BoneC" recursively:YES];
    
    //　モデルの各ノード
    arm_A = [arm childNodeWithName:@"BoneA" recursively:YES];
    arm_B = [arm childNodeWithName:@"BoneB" recursively:YES];
    
    //　SCNIKConstraint:IKの用意
    ik = [SCNIKConstraint inverseKinematicsConstraintWithChainRootNode:arm_root];
    //　モデルの末端に拘束条件として先ほど用意したIKを設定する
    arm_end.constraints = @[ik];
    ik.influenceFactor = 1.0;
    
    //　試しに動かしてみる
    [SCNTransaction begin];
    //　目標位置をSCNIKConstraintに与える
    ik.targetPosition = [scene.rootNode convertPosition:SCNVector3Make(0,-1,0) toNode:nil];
    
    [SCNTransaction commit];
     
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // set the scene to the view
    scnView.scene = scene;
        
    // show statistics such as fps and timing information
    scnView.showsStatistics = YES;

    // configure the view
    scnView.backgroundColor = [UIColor blackColor];
}

//　画面内をタッチしてIKの目標地点を動かす
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //　タッチイベントの取得
    UITouch *touch = [touches anyObject];
    //　タッチの位置
    CGPoint touchPoint =[touch locationInView:self.view];
    //　画面の大きさ
    float screenW = self.view.frame.size.width;
    float screenH = self.view.frame.size.height;
    //　移動先の座標の設定
    float movetoX = ((touchPoint.x - screenW/2.0)*8.0)/screenW;
    float movetoY = ((touchPoint.y - screenH/2.0)*8.0)/screenH*-1.0;
    //　IKの目標地点を設定（これで動く）
    ik.targetPosition = [scene.rootNode convertPosition:SCNVector3Make(movetoX,movetoY,0) toNode:nil];
    //　各ノードの角度を取ってみる
    NSLog(@"armA.angle.x:%.2f",arm_A.presentationNode.eulerAngles.x);
    NSLog(@"armB.angle.x:%.2f",arm_B.presentationNode.eulerAngles.x);
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
