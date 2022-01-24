using UnityEngine;
using UnityEditor;
using System.IO;
using UnityEditor.Animations;

public class CreatePrefab : EditorWindow
{
    #region -- 变量定义
    private static string mOutputPath = "";
    private static bool mIsCreateAnimatorController = true;

    private static AnimationClip mStart;
    private static AnimationClip mTake;
    private static AnimationClip mEnd;
    #endregion

    #region -- 系统函数
    private void OnGUI()
    {
        GUILayout.BeginVertical();

        //绘制标题
        GUILayout.Space(10);
        GUI.skin.label.fontSize = 24;
        GUI.skin.label.alignment = TextAnchor.MiddleCenter;
        GUILayout.Label("Create Prefabs");

        //绘制文本
        GUILayout.Space(10);
        mOutputPath = EditorGUILayout.TextField("Output Path:", mOutputPath);

        GUILayout.Space(10);
        mIsCreateAnimatorController = EditorGUILayout.Toggle("Create AnimaControl:", mIsCreateAnimatorController);

        if (GUILayout.Button("Create"))
        {
            CreatePrefabs();
        }

        GUILayout.EndVertical();
    }
    #endregion

    #region -- 自定义函数
    [MenuItem("Window/CreatePrefab")]
    public static void CreateWindow()
    {
        //绘制窗口
        EditorWindow.GetWindow(typeof(CreatePrefab), true, "Create Prefabs");
    }
    private static void CreatePrefabs()
    {
        Object[] _objs = Selection.GetFiltered(typeof(GameObject), SelectionMode.Unfiltered);
        if (_objs.Length == 0)
        {
            Debug.Log("你没有选择任何物体！");
            return;
        }
        for (int i = 0; i < _objs.Length; i++)
        {
            if (!Directory.Exists(Application.dataPath + "/" + mOutputPath))
            {
                Directory.CreateDirectory(Application.dataPath + "/" + mOutputPath);
            }
            GameObject _temObJ = _objs[i] as GameObject;
            string _outputPath = "";
            if (mOutputPath == "")
            {
                _outputPath = "Assets/";
            }
            else
            {
                _outputPath = "Assets/" + mOutputPath + "/";
            }
            GameObject _prefab = PrefabUtility.CreatePrefab(_outputPath + _temObJ.name + ".prefab", _temObJ);
            if (mIsCreateAnimatorController)
            {
                AnimatorController _animatorController = CreateAnimatorController(AssetDatabase.GetAssetPath(_objs[i]), _temObJ.name + ".controller", _outputPath + "AnimatorControllers");
                Animator _animator = _prefab.GetComponent<Animator>();
                if (_animator != null)
                {
                    _animator.runtimeAnimatorController = _animatorController;
                }
            }
        }
        AssetDatabase.Refresh();
    }
    private static AnimatorController CreateAnimatorController(string _assetsPath, string _controllerName, string _outPutPath)
    {
        //创建AnimatorController文件，保存在_outPutPath路径下
        if (!Directory.Exists(_outPutPath))
        {
            Directory.CreateDirectory(_outPutPath);
        }

        //生成动画控制器（AnimatorController）
        AnimatorController _animatorController = AnimatorController.CreateAnimatorControllerAtPath(_outPutPath + "/" + _controllerName);

        //添加参数（parameters）
        _animatorController.AddParameter("Normal", AnimatorControllerParameterType.Float);
        _animatorController.AddParameter("Play", AnimatorControllerParameterType.Bool);

        //得到它的Layer， 默认layer为base,可以拓展
        AnimatorControllerLayer _layer = _animatorController.layers[0];

        //把动画文件保存在我们创建的AnimatorController中
        AddStateTransition(_assetsPath, _layer);
        return _animatorController;
    }
    private static void AddStateTransition(string _assetsPath, AnimatorControllerLayer _layer)
    {
        //添加动画状态机（这里只是通过层得到根状态机，并未添加）
        AnimatorStateMachine _stateMachine = _layer.stateMachine;

        // 根据动画文件读取它的AnimationClip对象
        var _datas = AssetDatabase.LoadAllAssetsAtPath(_assetsPath);
        if (_datas.Length == 0)
        {
            Debug.Log(string.Format("Can't find clip in {0}", _assetsPath));
            return;
        }

        // 遍历读取模型中包含的动画片段
        foreach (var _data in _datas)
        {
            if (!(_data is AnimationClip))
            {
                continue;
            }
            AnimationClip _newClip = _data as AnimationClip;
            switch (_newClip.name)
            {
                case "Start":
                    mStart = _newClip;
                    break;
                case "End":
                    mEnd = _newClip;
                    break;
                case "Take":
                    mTake = _newClip;
                    break;
            }
        }

        // 先添加一个默认的空状态
        AnimatorState _emptyState = _stateMachine.AddState("Empty", new Vector3(_stateMachine.entryPosition.x + 200, _stateMachine.entryPosition.y, 0));

        // 添加与动画名称对应的装态（AnimatorState）到状态机中（AnimatorStateMachine）中，并设置状态
        AnimatorState _startState = _stateMachine.AddState(mStart.name, new Vector3(_stateMachine.entryPosition.x + 500, _stateMachine.entryPosition.y + 100, 0));
        _startState.motion = mStart;

        AnimatorState _endState = _stateMachine.AddState(mEnd.name, new Vector3(_stateMachine.entryPosition.x + 500, _stateMachine.entryPosition.y - 100, 0));
        _endState.motion = mEnd;

        AnimatorState _take01State = _stateMachine.AddState("Take01", new Vector3(_stateMachine.entryPosition.x + 800, _stateMachine.entryPosition.y + 100, 0));
        _take01State.motion = mTake;

        AnimatorState _take02State = _stateMachine.AddState("Take02", new Vector3(_stateMachine.entryPosition.x + 800, _stateMachine.entryPosition.y - 100, 0));
        _take02State.motion = mTake;
        _take02State.speed = -1;

        //连接每个状态，并添加切换条件
        AnimatorStateTransition _animatorStateTransition = _emptyState.AddTransition(_startState);
        _animatorStateTransition.AddCondition(AnimatorConditionMode.Greater, 0, "Normal");
        _animatorStateTransition.hasExitTime = false;
        _animatorStateTransition.duration = 0;

        _animatorStateTransition = _emptyState.AddTransition(_endState);
        _animatorStateTransition.AddCondition(AnimatorConditionMode.Less, 0, "Normal");
        _animatorStateTransition.hasExitTime = false;
        _animatorStateTransition.duration = 0;

        _animatorStateTransition = _startState.AddTransition(_take01State);
        _animatorStateTransition.AddCondition(AnimatorConditionMode.If, 0, "Play");
        _animatorStateTransition.hasExitTime = false;
        _animatorStateTransition.duration = 0;

        _animatorStateTransition = _endState.AddTransition(_take02State);
        _animatorStateTransition.AddCondition(AnimatorConditionMode.If, 0, "Play");
        _animatorStateTransition.hasExitTime = false;
        _animatorStateTransition.duration = 0;
    }
    #endregion

}