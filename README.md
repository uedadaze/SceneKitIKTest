（※: 2014年にQiitaに投稿していた古い記事になります。最新のiOSでは勝手が違っている可能性がございますのでご了承ください）

（※: Objective-Cで記述されております）

# 【SceneKit】SCNIKConstraintの使い方
iOS8のSceneKitにおいて、IK（逆運動学）処理を行うためのクラスにSCNIKConstraintがあります。これはSCNNodeとして配置されたモデルに対して拘束条件を加えるSCNConstraintのサブクラスとなっています。

本プロジェクトはこのSCNIKConstraintの使い方に関するチュートリアルとサンプルコードとなります。

## 3Dモデルの用意
まずIKを組み込む対象となるボーンの入った3Dモデルを用意します。今回はBlenderで以下のロボットアームのようなモデルを作りました。

![Readme_Robotarm](https://user-images.githubusercontent.com/5953832/87235927-13974d80-c41d-11ea-870b-5f00e394e9e0.png)

青い立方体を根、赤い立方体を末端としています。全部で4本のボーンが入っており、それぞれモデルの対応する部分に紐づけられています。モデルが完成したらdae形式でエクスポートします。

## 実装
先ほど作成した3Dモデルのdaeファイルをプロジェクトにインポートします。この時、モデルとボーンを含む親ノードを用意していなければ、用意してください。

![Readme_Robotarm2](https://user-images.githubusercontent.com/5953832/87235944-4ccfbd80-c41d-11ea-89d3-ec8b77a002ce.png)

プロジェクトナビゲーター（ファイル一覧）からdaeファイルを選べば上のような画面になります。daeファイルに記録されているシーンの中のノード一覧が見えますが、この左下に+ボタンがあり、これを押すことでノードを追加できます。　また、ノードを別なノードにドラッグすれば子ノードにすることもできます。上記の画像では、「Arm」というノードを作り、そこにモデル本体(Cube)とボーン(Armature)を入れています。

daeファイルの準備が終わったらいよいよ実装です。

まず、IKで動かしたいボーンの根っこの部分(ここでは"RootBone"という名前だとします)を表すSCNNodeと、ボーンの先端部分(ここでは"BoneC"とします)を表すSCNNodeをそれぞれ用意します。次にSCNIKConstraintのインスタンスを用意しますが、この時ボーンの根っこにあたるSCNNodeを指定する必要があるので、先ほどのRootBoneを表すSCNNodeのインスタンスを渡します。最後に、ボーンの先端部分に拘束条件として用意したSCNIKConstraintのインスタンスを割り当て、influenceFactor(動きへの影響度)を1.0にして準備完了です。

実際に動かすためには、SCNIKConstraintのtargetPositionプロパティに目標位置を与えてやればOKです。

この部分について、実際のコードは以下のようになります。

```
//　部位ごとのNodeの作成
SCNNode *arm_root = [arm childNodeWithName:@"RootBone" recursively:YES];
SCNNode *arm_end = [arm childNodeWithName:@"BoneC" recursively:YES];

//　SCNIKConstraint:IKの用意
SCNIKConstraint *ik = [SCNIKConstraint inverseKinematicsConstraintWithChainRootNode:arm_root];
//　モデルの末端に拘束条件として先ほど用意したIKを設定する
arm_end.constraints = @[ik];
//　影響度を設定
ik.influenceFactor = 1.0;

//　試しに動かしてみる
[SCNTransaction begin];
//　目標位置をSCNIKConstraintに与える
ik.targetPosition = [scene.rootNode convertPosition:SCNVector3Make(0,-1,0) toNode:nil];
[SCNTransaction commit];
```
