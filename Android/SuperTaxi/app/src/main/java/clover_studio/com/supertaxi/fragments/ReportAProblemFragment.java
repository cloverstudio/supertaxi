package clover_studio.com.supertaxi.fragments;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import clover_studio.com.supertaxi.R;
import clover_studio.com.supertaxi.base.BaseFragment;

/**
 * Created by ivoperic on 13/07/16.
 */
public class ReportAProblemFragment extends BaseFragment {

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_report_a_problem, container, false);
        return rootView;
    }

}
